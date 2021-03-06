import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct GithubChecks: GithubChecksUseCase {
    enum GithubChecksError: Error {
        case invalidRequest
    }

    private let modelLoader: ModelLoading
    private let ghToken: String
    private let repository: String
    private let decoder: Decoder

    // MARK: - Initializer

    public init(repository: String, ghToken: String, modelLoader: ModelLoading, decoder: Decoder) {
        self.repository = repository
        self.ghToken = ghToken
        self.modelLoader = modelLoader
        self.decoder = decoder
    }

    // MARK: - Internal Methods

    func createCheckRunRequest(payload: CheckRunRequestPayload)
        -> URLRequest?
    {
        return checkRunRequest(
            httpMethod: "POST",
            path: "/repos/\(repository)/check-runs",
            payload: payload
        )
    }

    func updateCheckRunRequest(checkRunId: Int, payload: CheckRunRequestPayload)
        -> URLRequest?
    {
        return checkRunRequest(
            httpMethod: "PATCH",
            path: "/repos/\(repository)/check-runs/\(checkRunId)",
            payload: payload
        )
    }

    // MARK: - Private methods

    private func checkRunRequest<Payload>(httpMethod: String, path: String, payload: Payload? = nil)
        -> URLRequest? where Payload: Encodable
    {
        var httpBody: Data?
        if let payload = payload {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            httpBody = try? encoder.encode(payload)
        }

        return URLRequest.build(
            .init(
                host: Configs.host,
                httpMethod: httpMethod,
                path: path,
                httpBody: httpBody,
                headers: [
                    "Accept": Configs.accept,
                    "Authorization": "Bearer \(ghToken)",
                ]
            ))
    }

    // MARK: - Public Methods

    public func createCheckRun(payload: CheckRunRequestPayload) async throws -> CheckRunResponse {
        guard let request = createCheckRunRequest(payload: payload) else {
            throw GithubChecksError.invalidRequest
        }
        return try await modelLoader.load(request: request, decoder: decoder)
    }

    public func updateCheckRun(checkRunId: Int, payload: CheckRunRequestPayload) async throws -> CheckRunResponse {
        guard let request = updateCheckRunRequest(checkRunId: checkRunId, payload: payload) else {
            throw GithubChecksError.invalidRequest
        }
        return try await modelLoader.load(request: request, decoder: decoder)
    }
}

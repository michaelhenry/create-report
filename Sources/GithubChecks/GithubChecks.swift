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

    // MARK: - Initializer

    public init(repository: String, ghToken: String, modelLoader: ModelLoading) {
        self.repository = repository
        self.ghToken = ghToken
        self.modelLoader = modelLoader
    }

    // MARK: - Internal Methods
    func createCheckRunRequest(payload: CheckRunRequestPayload)
    -> URLRequest? {
        return checkRunRequest(
            httpMethod: "POST",
            path: "/repos/\(repository)/check-runs",
            payload: payload)
    }

    func updateCheckRunRequest(checkRunId: Int, payload: CheckRunRequestPayload)
    -> URLRequest? {
        return checkRunRequest(
            httpMethod: "PATCH",
            path: "/repos/\(repository)/check-runs/\(checkRunId)",
            payload: payload)
    }

    // MARK: - Private methods

    private func checkRunRequest<Payload>(httpMethod: String, path: String, payload: Payload? = nil)
    -> URLRequest? where Payload: Encodable {

        var httpBody: Data? = nil
        if let payload = payload {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            httpBody = try? encoder.encode(payload)
        }

        return URLRequest.build(
            host: Configs.host,
            httpMethod: httpMethod,
            path: path,
            httpBody: httpBody,
            headers: [
                "Accept": Configs.accept,
                "Authorization": "Bearer \(ghToken)",
            ])
    }

    // MARK: - Public Methods

    public func createCheckRun(payload: CheckRunRequestPayload, completion: @escaping ((Result<CheckRunResponse, Error>) -> Void)) {
        guard let request = createCheckRunRequest(payload: payload) else {
            completion(.failure(GithubChecksError.invalidRequest))
            return
        }
        modelLoader.load(request: request, completion: completion)
    }

    public func updateCheckRun(checkRunId: Int, payload: CheckRunRequestPayload, completion: @escaping ((Result<CheckRunResponse, Error>) -> Void)) {
        guard let request = updateCheckRunRequest(checkRunId: checkRunId, payload: payload) else {
            completion(.failure(GithubChecksError.invalidRequest))
            return
        }
        modelLoader.load(request: request, completion: completion)
    }
}

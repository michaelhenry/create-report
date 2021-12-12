import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct GithubChecks {

    enum GithubChecksError: Error {
        case invalidRequest
    }

    private let ghToken: String
    private let repo: String
    private let owner: String

    public init(owner: String, repo: String, ghToken: String) {
        self.owner = owner
        self.repo = repo
        self.ghToken = ghToken
    }

    public func createCheckRunRequest(payload: CheckRunRequestPayload) throws
    -> URLRequest {
        return try checkRunRequest(
            httpMethod: "POST",
            path: "/repos/\(owner)/\(repo)/check-runs",
            payload: payload)
    }

    public func updateCheckRunRequest(checkRunId: Int, payload: CheckRunRequestPayload) throws
    -> URLRequest {
        return try checkRunRequest(
            httpMethod: "PATCH",
            path: "/repos/\(owner)/\(repo)/check-runs/\(checkRunId)",
            payload: payload)
    }

    private func checkRunRequest<Payload>(httpMethod: String, path: String, payload: Payload? = nil) throws
    -> URLRequest where Payload: Encodable {

        var httpBody: Data? = nil
        if let payload = payload {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            httpBody = try encoder.encode(payload)
        }

        guard let request = URLRequest.build(
            host: Configs.host,
            httpMethod: httpMethod,
            path: path,
            httpBody: httpBody,
            headers: [
                "Accept": Configs.accept,
                "Authorization": "Bearer \(ghToken)",
            ])
        else {
            throw GithubChecksError.invalidRequest
        }
        return request
    }
}

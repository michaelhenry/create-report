import Foundation

public protocol GithubChecksUseCase {
    func createCheckRun(payload: CheckRunRequestPayload) async throws -> CheckRunResponse
    func updateCheckRun(checkRunId: Int, payload: CheckRunRequestPayload) async throws -> CheckRunResponse
}

import Foundation

public protocol GithubChecksUseCase {
    func createCheckRun(payload: CheckRunRequestPayload, completion: @escaping((Result<CheckRunResponse, Error>) -> Void))
    func updateCheckRun(checkRunId: Int, payload: CheckRunRequestPayload, completion: @escaping((Result<CheckRunResponse, Error>) -> Void))
}

import Foundation

public struct CheckRunRequestPayload: Codable, Equatable {
    public let name: String?
    public let headSha: String?

    public let conclusion: CheckRunConclusion?
    public let status: CheckRunStatus?
    public let output: CheckRunOutput?

    public init(
        name: String? = nil,
        headSha: String? = nil,
        conclusion: CheckRunConclusion? = nil,
        status: CheckRunStatus? = nil,
        output: CheckRunOutput? = nil
    ) {
        self.name = name
        self.headSha = headSha
        self.conclusion = conclusion
        self.status = status
        self.output = output
    }
}

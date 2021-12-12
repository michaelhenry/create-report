import Foundation

public struct CheckRunResponse: Decodable {
    public let id: Int
    public let headSha: String
    public let nodeId: String
    public let externalId: String
    public let url: String
    public let htmlUrl: String
    public let detailsUrl: String
    public let status: CheckRunStatus
    public let conclusion: CheckRunConclusion
    public let startedAt: String
    public let completedAt: String
    public let output: CheckRunOutput
}

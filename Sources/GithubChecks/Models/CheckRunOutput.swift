import Foundation

public struct CheckRunOutput: Codable {
    public let title: String
    public let summary: String

    public init(title: String, summary: String) {
        self.title = title
        self.summary = summary
    }
}

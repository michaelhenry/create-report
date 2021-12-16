import Foundation

public struct CheckRunOutput: Codable, Equatable {
    public let title: String
    public let summary: String

    public init(title: String, summary: String) {
        self.title = title
        self.summary = summary
    }
}

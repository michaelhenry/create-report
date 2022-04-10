import Foundation

public struct MarkdownSummaryRenderer: SummaryRenderer {
    
    private let path: String
    
    public init(path: String) {
        self.path = path
    }
    
    public func render() async throws -> String {
        return try String(contentsOfFile: path)
    }
}

import Foundation

public struct MarkdownSummaryRenderer: SummaryRenderer {
    
    public init() {}
    
    public func render(path: String) throws -> String {
        return try String(contentsOfFile: path)
    }
}

import Foundation

public struct HTMLSummaryRenderer: SummaryRenderer {
    
    public init() {}

    public func render(path: String) throws -> String {
        let command =  "cat \(path) | python md.py"
        return shell(command: command)
    }
}

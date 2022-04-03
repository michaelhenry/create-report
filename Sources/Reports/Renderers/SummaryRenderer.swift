import Foundation

public protocol SummaryRenderer {
    init()
    func render(path: String) throws -> String
}

import Foundation

public protocol SummaryRenderer {
    func render() async throws -> String
}

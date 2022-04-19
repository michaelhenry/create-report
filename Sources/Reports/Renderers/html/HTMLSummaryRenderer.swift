import Foundation

public struct HTMLSummaryRenderer: SummaryRenderer {
    private var tempPyFile: String = {
        let dirPath = NSTemporaryDirectory()
        return dirPath.appending("\(UUID().uuidString).py")
    }()

    private let path: String

    public init(path: String) {
        self.path = path
    }

    public func render() async throws -> String {
        try """
        import sys
        from markdownify import markdownify as md
        html = ""
        for line in sys.stdin:
            html += line
        print(md(html))
        """.data(using: .utf8)!.write(to: URL(fileURLWithPath: tempPyFile))
        defer { try? FileManager.default.removeItem(atPath: tempPyFile) }
        let command = "cat \(path) | python \(tempPyFile)"
        return try shell(command: command)
    }
}

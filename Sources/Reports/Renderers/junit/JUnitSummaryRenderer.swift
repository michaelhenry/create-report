import Foundation
import SimpleXMLParser

public struct JUnitSummaryRenderer: SummaryRenderer {
    private let path: String

    public init(path: String) {
        self.path = path
    }

    public func render() async throws -> String {
        let junitFile = try String(contentsOfFile: path)
        let xmlParser = SimpleXMLParser()
        var md = ""
        let root = try await xmlParser.parse(xml: junitFile)
        root.children.forEach { testSuites in
            md += render(testSuites: testSuites)
        }
        return md
    }

    private func render(testSuites: Element) -> String {
        var md = ""
        testSuites.children.forEach { testSuite in
            md += render(testSuite: testSuite)
        }
        return md
    }

    private func render(testSuite: Element) -> String {
        guard let name = testSuite.attributes["name"] else {
            return ""
        }

        var md = """

        ## \(name)

        \(createRow(columns: ["&nbsp;", "Name", "Time (sec)", "Message"]))
        \(createRow(columns: ["---", ":---", "---:", "---"]))

        """

        testSuite.children.forEach { testCase in
            md += render(testCase: testCase) + "\n"
        }
        md += "\n"
        return md
    }

    private func render(testCase: Element) -> String {
        guard let name = testCase.attributes["name"],
              let time = testCase.attributes["time"]
        else {
            return ""
        }
        let failureMessages = testCase.children
            .filter { $0.name.lowercased() == "failure" }
            .compactMap { $0.attributes["message"] }
            .joined()

        let result = failureMessages.isEmpty ? "✅" : "❌"
        return """
        \(createRow(columns: [result, name, time, failureMessages]))
        """
    }

    private func createRow(columns: [String]) -> String {
        return "| " + columns.joined(separator: " | ") + " |"
    }
}

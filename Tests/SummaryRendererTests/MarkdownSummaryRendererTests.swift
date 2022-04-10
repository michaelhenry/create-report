import XCTest
@testable import Reports

class MarkdownSummaryRendererTests: XCTestCase {

    private var tempFile: String = {
        let dirPath = NSTemporaryDirectory()
        return dirPath.appending("\(UUID().uuidString).md")
    }()

    func testJUnitSummaryRenderer() async {
        // Summary is just markodwn.
        do {
            try """
            # h1
            # h2
            # h3
            """.data(using: .utf8)!.write(to: URL(fileURLWithPath: tempFile))

            let expectation = """
            # h1
            # h2
            # h3
            """
            let markdownSummaryRenderer = MarkdownSummaryRenderer(path: tempFile)
            let md = try await markdownSummaryRenderer.render()
            XCTAssertEqual(md, expectation)
        } catch {
            XCTFail("fail")
        }
    }

    override func tearDown() {
        super.tearDown()
        try? FileManager.default.removeItem(atPath: tempFile)
    }
}
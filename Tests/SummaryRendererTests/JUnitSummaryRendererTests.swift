import XCTest
@testable import Reports

class JUnitSummaryRendererTests: XCTestCase {
    
    private var tempFile: String = {
        let dirPath = NSTemporaryDirectory()
        return dirPath.appending("\(UUID().uuidString).junit")
    }()
    
    func testJUnitSummaryRenderer() async {
        do {
            try """
            <?xml version="1.0" encoding="UTF-8"?>
            <testsuites>
              <testsuite tests="3" failures="1" disabled="0" errors="0" time="0.006" name="SwiftTests">
                <testcase classname="Tests.SwiftTests" name="testShouldPass" time="0.001"></testcase>
                <testcase classname="Tests.SwiftTests" name="testShouldPassAgain" time="0.004"></testcase>
                <testcase classname="Tests.SwiftTests" name="testFail" time="0.001">
                    <failure message="Assertion failed"></failure>
                </testcase>
              </testsuite>
              <testsuite tests="1" failures="1" disabled="0" errors="0" time="0.001" name="AnotherTests">
                <testcase classname="Tests.AnotherTests" name="testShouldFail" time="0.001">
                  <failure message="Oops, something went wrong!"></failure>
                </testcase>
              </testsuite>
            </testsuites>
            """.data(using: .utf8)!.write(to: URL(fileURLWithPath: tempFile))
            
            let expectation = """
            
            ## SwiftTests

            | &nbsp; | Name | Time (sec) | Message |
            | --- | :--- | ---: | --- |
            | ✅ | testShouldPass | 0.001 |  |
            | ✅ | testShouldPassAgain | 0.004 |  |
            | ❌ | testFail | 0.001 | Assertion failed |


            ## AnotherTests

            | &nbsp; | Name | Time (sec) | Message |
            | --- | :--- | ---: | --- |
            | ❌ | testShouldFail | 0.001 | Oops, something went wrong! |

            
            """
            let junitSummaryRenderer = JUnitSummaryRenderer(path: tempFile)
            let md = try await junitSummaryRenderer.render()
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

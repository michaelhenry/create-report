import Foundation
import XCTest

@testable import GithubChecks

final class GithubChecksTests: XCTestCase {

    func testCreateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####")
        let request = try ghChecks.createCheckRunRequest(payload: .init(name: "Code coverage", headSha: "XXXXXX"))
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(
            String(data: request.httpBody!, encoding: .utf8),
            "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\"}")
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs")
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }

    func testUpdateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####")
        let request = try ghChecks.updateCheckRunRequest(
            checkRunId: 1,
            payload: .init(
                name: "Code coverage",
                headSha: "XXXXXX",
                output: .init(
                    title: "Code coverage report",
                    summary: "Here is the summary of the report")))
        XCTAssertEqual(request.httpMethod, "PATCH")
        XCTAssertEqual(
            String(data: request.httpBody!, encoding: .utf8),
            "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\",\"output\":{\"title\":\"Code coverage report\",\"summary\":\"Here is the summary of the report\"}}")
        XCTAssertEqual(request.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs/1")
        XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }
}

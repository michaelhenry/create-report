import Foundation
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import XCTest

@testable import GithubChecks

class MockModelLoader: ModelLoading {
    func load<Model>(request: URLRequest, completion: @escaping ((Result<Model, Error>) -> Void)) where Model : Decodable {

    }
}

final class GithubChecksTests: XCTestCase {

    func testCreateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: MockModelLoader())
        let request = ghChecks.createCheckRunRequest(payload: .init(name: "Code coverage", headSha: "XXXXXX"))
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(
            try request?.httpBody?
                .decode(to: CheckRunRequestPayload.self),
            try "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\"}"
                .decode(to: CheckRunRequestPayload.self))
        XCTAssertEqual(request?.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }

    func testUpdateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: MockModelLoader())
        let request = ghChecks.updateCheckRunRequest(
            checkRunId: 1,
            payload: .init(
                name: "Code coverage",
                headSha: "XXXXXX",
                output: .init(
                    title: "Code coverage report",
                    summary: "Here is the summary of the report")))
        XCTAssertEqual(request?.httpMethod, "PATCH")
        XCTAssertEqual(
            try request?.httpBody?
                .decode(to: CheckRunRequestPayload.self),
            try "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\",\"output\":{\"title\":\"Code coverage report\",\"summary\":\"Here is the summary of the report\"}}"
                .decode(to: CheckRunRequestPayload.self))
        XCTAssertEqual(request?.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs/1")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }
}

extension String {
    func decode<Model>(to: Model.Type) throws -> Model where Model: Decodable {
        return try data(using: .utf8)!.decode(to: to)
    }
}

extension Data {
    func decode<Model>(to: Model.Type) throws -> Model where Model: Decodable {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: self)
    }
}

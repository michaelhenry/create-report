import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif
import XCTest


@testable import GithubChecks

class MockModelLoader: ModelLoading {

    private var stubData: ((URLRequest) -> String)?

    func stub(_ stubData: @escaping ((URLRequest) -> String)) {
        self.stubData = stubData
    }

    func load<Model>(request: URLRequest, decoder: Decoder) async throws -> Model where Model : Decodable {
        let data = stubData?(request).data(using: .utf8) ?? Data()
        return try decoder.decode(Model.self, from: data)
    }
}

final class GithubChecksTests: XCTestCase {
    private lazy var decoder: Decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func testCreateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: MockModelLoader(), decoder: decoder)
        let request = ghChecks.createCheckRunRequest(payload: .init(name: "Code coverage", headSha: "XXXXXX"))
        XCTAssertEqual(request?.httpMethod, "POST")
        XCTAssertEqual(
            try decoder.decode(CheckRunRequestPayload.self, from: request!.httpBody!),
            try decoder.decode(CheckRunRequestPayload.self, from: "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\"}".data(using: .utf8)!))
        XCTAssertEqual(request?.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }

    func testUpdateChecksRequest() throws {
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: MockModelLoader(), decoder: decoder)
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
            try decoder.decode(CheckRunRequestPayload.self, from: request!.httpBody!),
            try decoder.decode(CheckRunRequestPayload.self, from: "{\"name\":\"Code coverage\",\"head_sha\":\"XXXXXX\",\"output\":{\"title\":\"Code coverage report\",\"summary\":\"Here is the summary of the report\"}}".data(using: .utf8)!))
        XCTAssertEqual(request?.allHTTPHeaderFields?["Accept"], "application/vnd.github.v3+json")
        XCTAssertEqual(request?.url?.absoluteString, "https://api.github.com/repos/michaelhenry/ios/check-runs/1")
        XCTAssertEqual(request?.allHTTPHeaderFields?["Authorization"], "Bearer ####AUTHTOKEN####")
    }

    func testCreateCheckRun() async throws {
        let modelLoader = MockModelLoader()
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: modelLoader, decoder: decoder)
        let payload = CheckRunRequestPayload(name: "Code coverage", headSha: "ce587453ced02b1526dfb4cb910479d431683101")
        modelLoader.stub { [successResponse] _ in successResponse }
        let response = try await ghChecks.createCheckRun(payload: payload)
        XCTAssertEqual(response.id, 4)
        XCTAssertEqual(response.headSha, "ce587453ced02b1526dfb4cb910479d431683101")
        XCTAssertEqual(response.conclusion, .success)
        XCTAssertEqual(response.status, .inProgress)
    }

    func testUpdateCheckRun() async throws {
        let modelLoader = MockModelLoader()
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: modelLoader, decoder: decoder)
        let payload = CheckRunRequestPayload(name: "Code coverage", headSha: "ce587453ced02b1526dfb4cb910479d431683101")
        modelLoader.stub { [successResponse] _ in successResponse }
        let response = try await ghChecks.updateCheckRun(checkRunId: 4, payload: payload)
        XCTAssertEqual(response.id, 4)
    }
}

extension GithubChecksTests {
    var successResponse: String {
        """
        {
            "id": 4,
            "head_sha": "ce587453ced02b1526dfb4cb910479d431683101",
            "node_id": "MDg6Q2hlY2tSdW40",
            "external_id": "42",
            "url": "https://api.github.com/repos/github/hello-world/check-runs/4",
            "html_url": "https://github.com/github/hello-world/runs/4",
            "details_url": "https://example.com",
            "status": "in_progress",
            "conclusion": "success",
            "started_at": "2022-04-15T15:14:52Z",
            "completed_at": "2022-04-15T15:15:59Z",
            "output": {
                "title": "Mighty Readme report",
                "summary": "There are 0 failures, 2 warnings, and 1 notice.",
                "text": "You may have some misspelled words on lines 2 and 4. You also may want to add a section in your README about how to install your app.",
                "annotations_count": 2,
                "annotations_url": "https://api.github.com/repos/github/hello-world/check-runs/4/annotations"
            },
            "name": "mighty_readme",
            "check_suite": {
                "id": 5
            },
            "app": {
                "id": 1,
                "slug": "octoapp",
                "node_id": "MDExOkludGVncmF0aW9uMQ==",
                "owner": {
                "login": "github",
                "id": 1,
                "node_id": "MDEyOk9yZ2FuaXphdGlvbjE=",
                "url": "https://api.github.com/orgs/github",
                "repos_url": "https://api.github.com/orgs/github/repos",
                "events_url": "https://api.github.com/orgs/github/events",
                "avatar_url": "https://github.com/images/error/octocat_happy.gif",
                "gravatar_id": "",
                "html_url": "https://github.com/octocat",
                "followers_url": "https://api.github.com/users/octocat/followers",
                "following_url": "https://api.github.com/users/octocat/following{/other_user}",
                "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
                "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
                "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
                "organizations_url": "https://api.github.com/users/octocat/orgs",
                "received_events_url": "https://api.github.com/users/octocat/received_events",
                "type": "User",
                "site_admin": true
                },
                "name": "Octocat App",
                "description": "",
                "external_url": "https://example.com",
                "html_url": "https://github.com/apps/octoapp",
                "created_at": "2017-07-08T16:18:44-04:00",
                "updated_at": "2017-07-08T16:18:44-04:00",
                "permissions": {
                "metadata": "read",
                "contents": "read",
                "issues": "write",
                "single_file": "write"
                },
                "events": [
                "push",
                "pull_request"
                ]
            },
            "pull_requests": [
                {
                "url": "https://api.github.com/repos/github/hello-world/pulls/1",
                "id": 1934,
                "number": 3956,
                "head": {
                    "ref": "say-hello",
                    "sha": "3dca65fa3e8d4b3da3f3d056c59aee1c50f41390",
                    "repo": {
                    "id": 526,
                    "url": "https://api.github.com/repos/github/hello-world",
                    "name": "hello-world"
                    }
                },
                "base": {
                    "ref": "master",
                    "sha": "e7fdf7640066d71ad16a86fbcbb9c6a10a18af4f",
                    "repo": {
                    "id": 526,
                    "url": "https://api.github.com/repos/github/hello-world",
                    "name": "hello-world"
                    }
                }
                }
            ]
        }
        """
    }
}

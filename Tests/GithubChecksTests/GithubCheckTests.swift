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

    private var responseString = ""

    func mockResponse(with responseString: String) {
        self.responseString = responseString
    }

    func load<Model>(request: URLRequest) async throws -> Model where Model : Decodable {
        return try responseString.decode(to: Model.self)
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

    func testCreateCheckRun() async throws {
        let modelLoader = MockModelLoader()
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: modelLoader)
        let payload = CheckRunRequestPayload(name: "Code coverage", headSha: "ce587453ced02b1526dfb4cb910479d431683101")
        modelLoader.mockResponse(with: successResponse)
        let response = try await ghChecks.createCheckRun(payload: payload)
        XCTAssertEqual(response.id, 4)
    }

    func testUpdateCheckRun() async throws {
        let modelLoader = MockModelLoader()
        let ghChecks = GithubChecks(repository: "michaelhenry/ios", ghToken: "####AUTHTOKEN####", modelLoader: modelLoader)
        let payload = CheckRunRequestPayload(name: "Code coverage", headSha: "ce587453ced02b1526dfb4cb910479d431683101")
        modelLoader.mockResponse(with: successResponse)
        let response = try await ghChecks.updateCheckRun(checkRunId: 4, payload: payload)
        XCTAssertEqual(response.id, 4)
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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Model.self, from: self)
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
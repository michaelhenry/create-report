//
//  File.swift
//  
//
//  Created by Michael Henry Pantaleon on 5/5/2022.
//

import Foundation
import ArgumentParser
import XCTest
#if canImport(_Concurrency)
import _Concurrency
#endif
@testable import GHCheckCommand

class GHCheckCommandTests: XCTestCase {

    func testGHCheckCommand() async throws {
        let ghChecks = try parse(GHCheckCommand.self, [
            "create-report",
            "--title", "Hello world.",
            "--path", "sample.md",
            "--format", "markdown",
            "--repository", "michaelhenry/create-report",
            "--head-sha", "any-head-sha",
            "--github-token", "any-token"
        ])
        XCTAssertEqual(ghChecks.command, "create-report")
        XCTAssertEqual(ghChecks.title, "Hello world.")
        XCTAssertEqual(ghChecks.path, "sample.md")
        XCTAssertEqual(ghChecks.format, "markdown")
        XCTAssertEqual(ghChecks.repository, "michaelhenry/create-report")
        XCTAssertEqual(ghChecks.headSha, "any-head-sha")
        XCTAssertEqual(ghChecks.githubToken, "any-token")
    }

    private func parse<T>(_ type: T.Type, _ arguments: [String]) throws -> T where T: AsyncParsableCommand  {
        return try XCTUnwrap(GHCheckCommand.parseAsRoot(arguments) as? T)
    }
}

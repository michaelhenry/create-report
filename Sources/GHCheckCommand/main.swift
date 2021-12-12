import ArgumentParser
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import GithubChecks

enum GHCheckCommandError: Error {
    case unsupportedCommand
    case missingGithubToken
    case other(Error)
}

struct GHCheckCommand: ParsableCommand {

    @Option(help: "The title of the report")
    var reportName: String

    @Option(help: "The summary of the report. (Markdown is supported)")
    var reportSummary: String

    @Option(help: "Eg. apple/swift")
    var repository: String

    @Option(help: "HEAD SHA, eg. ${{ github.event.pull_request.head.sha }}")
    var headSha: String

    @Option(help: "Your github token. eg. ${{ secrets.GITHUB_TOKEN }}")
    var githubToken: String

    @Argument(help: "Command eg. create-report | update-report")
    var command: String

    mutating func run() throws {
        try execute(command: command)
    }

    private func execute(command: String) throws {
        let session = URLSession(configuration: .default)
        switch command {
        case "create-report":

            let ghChecks = GithubChecks(
                repository: repository,
                ghToken: githubToken)
            let request = try ghChecks.createCheckRunRequest(
                payload: .init(
                    name: reportName,
                    headSha: headSha,
                    conclusion: .success,
                    status: .completed,
                    output: .init(
                        title: reportName,
                        summary: reportSummary)
                ))
            session.dataTask(with: request) { data, _, error in
                if let error = error {
                    GHCheckCommand.exit(withError: error)
                }
                print(String(data: data ?? Data(), encoding: .utf8) ?? "")
                GHCheckCommand.exit(withError: nil)
            }
            .resume()
            dispatchMain()
        default:
            throw GHCheckCommandError.unsupportedCommand
        }
    }
}

GHCheckCommand.main()

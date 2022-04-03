import ArgumentParser
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif
import GithubChecks
import Reports

enum GHCheckCommandError: Error {
    case unsupportedCommand
    case missingGithubToken
    case other(Error)
}

enum SummaryDataFormat: String, Codable, CaseIterable {
    case markdown
    case html

    var summaryRenderer: SummaryRenderer.Type {
        switch self {
        case .html:
            return HTMLSummaryRenderer.self
        case .markdown:
            return MarkdownSummaryRenderer.self
        }
    }
}

struct GHCheckCommand: ParsableCommand {

    @Option(help: "The title of the report")
    var title: String

    @Option(help: "The data format of the summary. Options are \(SummaryDataFormat.allCases). The default value is 'markdown'")
    var format: String = SummaryDataFormat.markdown.rawValue

    @Option(help: "The path of the summary report")
    var path: String

    @Option(help: "Eg. apple/swift")
    var repository: String

    @Option(help: "HEAD SHA, eg. ${{ github.event.pull_request.head.sha }}")
    var headSha: String

    @Option(help: "Your github token. eg. ${{ secrets.GITHUB_TOKEN }}")
    var githubToken: String

    @Argument(help: "Command eg. create-report")
    var command: String

    func run() throws {
        switch command {
        case "create-report":
            try createReport()
        default:
            GHCheckCommand.exit(withError: GHCheckCommandError.unsupportedCommand)
        }
        dispatchMain()
    }

    private func createReport() throws {
        guard
            let dataFormat = SummaryDataFormat(rawValue: format.lowercased())
        else { fatalError("Invalid summary data format. Options are \(SummaryDataFormat.allCases)") }

        let payload = CheckRunRequestPayload(
            name: title,
            headSha: headSha,
            conclusion: .success,
            status: .completed,
            output: .init(
                title: title,
                summary: try dataFormat.summaryRenderer.init().render(path: path)))

        let session = URLSession(configuration: .default)
        let ghChecks = GithubChecks(repository: repository, ghToken: githubToken, modelLoader: session)
        ghChecks.createCheckRun(payload: payload) { result in
            switch result {
            case .success:
                GHCheckCommand.exit(withError: nil)
            case .failure(let error):
                GHCheckCommand.exit(withError: error)
            }
        }
    }
}

GHCheckCommand.main()

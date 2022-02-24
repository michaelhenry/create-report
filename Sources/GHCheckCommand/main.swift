import ArgumentParser
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif
import GithubChecks

enum GHCheckCommandError: Error {
    case unsupportedCommand
    case missingGithubToken
    case other(Error)
}

enum SummaryDataType: String, Codable {
    case file
    case string
}

enum SummaryDataFormat: String, Codable {
    case markdown
    case html
}

struct GHCheckCommand: ParsableCommand {

    @Option(help: "The title of the report")
    var reportTitle: String

    @Option(help: "The data type of the summary, either 'string' or 'file'. The default value is 'string'")
    var reportSummaryDataType: String = SummaryDataType.string.rawValue

    @Option(help: "The data format of the summary, either 'markdown' or 'html'. The default value is 'markdown'")
    var reportSummaryDataFormat: String = SummaryDataFormat.markdown.rawValue

    @Option(help: "The summary of the report")
    var reportSummary: String

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
        let session = URLSession(configuration: .default)
        var summary = reportSummary
        if reportSummaryDataType == SummaryDataType.file.rawValue {
            switch reportSummaryDataFormat.lowercased() {
                case "html":
                    summary = shell(command: "cat \(reportSummary) | python md.py")
                default:
                    summary = try String(contentsOfFile: reportSummary)
            }

        }

        let payload = CheckRunRequestPayload(
            name: reportTitle,
            headSha: headSha,
            conclusion: .success,
            status: .completed,
            output: .init(
                title: reportTitle,
                summary: summary)
        )

        let ghChecks = GithubChecks(
            repository: repository,
            ghToken: githubToken,
            modelLoader: session)

        ghChecks.createCheckRun(payload: payload) { result in
            switch result {
            case .success(let model):
                print("CHECK URL:", model.url)
                GHCheckCommand.exit(withError: nil)
            case .failure(let error):
                GHCheckCommand.exit(withError: error)
            }
        }
    }
}

GHCheckCommand.main()

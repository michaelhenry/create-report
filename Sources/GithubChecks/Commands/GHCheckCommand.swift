import ArgumentParser
import Foundation
import Reports
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif

public enum GHCheckCommandError: Error {
    case unsupportedCommand
    case missingGithubToken
    case other(Error)
}

public enum SummaryDataFormat: String, Codable, CaseIterable {
    case markdown
    case html
    case junit

    func summaryRenderer(path: String) -> SummaryRenderer {
        switch self {
        case .html:
            return HTMLSummaryRenderer(path: path)
        case .markdown:
            return MarkdownSummaryRenderer(path: path)
        case .junit:
            return JUnitSummaryRenderer(path: path)
        }
    }
}

public struct GHCheckCommand: AsyncParsableCommand {
    @Option(help: "The title of the report")
    public var title: String

    @Option(help: "The data format of the summary. Options are \(SummaryDataFormat.allCases.map { $0.rawValue }). The default value is 'markdown'")
    public var format: String = SummaryDataFormat.markdown.rawValue

    @Option(help: "The path of the summary report")
    public var path: String

    @Option(help: "Eg. apple/swift")
    public var repository: String

    @Option(help: "HEAD SHA, eg. ${{ github.event.pull_request.head.sha }}")
    public var headSha: String

    @Option(help: "Your github token. eg. ${{ secrets.GITHUB_TOKEN }}")
    public var githubToken: String

    @Argument(help: "Command eg. create-report")
    public var command: String

    public init() {}

    public func run() async throws {
        switch command {
        case "create-report":
            try await createReport()
        default:
            GHCheckCommand.exit(withError: GHCheckCommandError.unsupportedCommand)
        }
        dispatchMain()
    }

    private func createReport() async throws {
        guard
            let dataFormat = SummaryDataFormat(rawValue: format.lowercased())
        else { fatalError("Invalid summary data format. Options are \(SummaryDataFormat.allCases.map { $0.rawValue })") }

        let summary = try await dataFormat.summaryRenderer(path: path).render()
        let payload = CheckRunRequestPayload(
            name: title,
            headSha: headSha,
            conclusion: .success,
            status: .completed,
            output: .init(title: title, summary: summary)
        )
        let session = URLSession(configuration: .default)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let ghChecks = GithubChecks(repository: repository, ghToken: githubToken, modelLoader: session, decoder: decoder)
        let response = try await ghChecks.createCheckRun(payload: payload)
        print("RESPONSE IS", response)
        GHCheckCommand.exit(withError: nil)
    }
}

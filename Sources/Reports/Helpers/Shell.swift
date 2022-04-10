import Foundation

extension Process {
    public func shell(command: String) throws -> String {
        launchPath = "/bin/bash"
        arguments = ["-c", command]
        let outputPipe = Pipe()
        standardOutput = outputPipe
        try run()
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public func shell(command: String, arguments: String...) throws -> String {
    let process = Process()
    let command = "\(command) \(arguments.joined(separator: " "))"
    return try process.shell(command: command)
}

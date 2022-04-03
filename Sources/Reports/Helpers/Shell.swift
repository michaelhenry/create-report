import Foundation

extension Process {
    public func shell(command: String) -> String {
        launchPath = "/bin/bash"
        arguments = ["-c", command]
        let outputPipe = Pipe()
        standardOutput = outputPipe
        launch()
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public func shell(command: String, arguments: String...) -> String {
    let process = Process()
    let command = "\(command) \(arguments.joined(separator: " "))"
    return process.shell(command: command)
}
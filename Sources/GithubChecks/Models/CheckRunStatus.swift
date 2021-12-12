import Foundation

public enum CheckRunStatus: String, Codable {
    case queued
    case inProgress = "in_progress"
    case completed
}

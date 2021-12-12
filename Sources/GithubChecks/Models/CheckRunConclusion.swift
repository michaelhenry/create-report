import Foundation

public enum CheckRunConclusion: String, Codable {
    case actionRequired = "action_required"
    case cancelled
    case failure
    case neutral
    case success
    case skipped
    case stale
    case timedOut = "timed_out"
}

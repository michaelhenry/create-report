import Foundation

enum CheckRunError: Error {
    case responseError(CheckRunResponseError)
}

struct CheckRunResponseError: Decodable {
    let message: String
    let documentationUrl: String
}

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

    struct RequestInput {
        var scheme: String = "https"
        var host: String = ""
        var httpMethod: String = "GET"
        var path: String = "/"
        var queryItems: [URLQueryItem]? = nil
        var httpBody: Data? = nil
        var headers: [String: String]? = nil
    }
    
    static func build(_ input: RequestInput) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = input.scheme
        urlComponents.host = input.host
        urlComponents.path = input.path
        urlComponents.queryItems = input.queryItems

        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = input.httpMethod
        request.httpBody = input.httpBody
        input.headers?.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
}

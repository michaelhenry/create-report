import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {

    static func build(
        scheme: String = "https",
        host: String,
        httpMethod: String = "GET",
        path: String = "/",
        queryItems: [URLQueryItem]? = nil,
        httpBody: Data? = nil,
        headers: [String: String] = [:])
    -> URLRequest? {

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
}

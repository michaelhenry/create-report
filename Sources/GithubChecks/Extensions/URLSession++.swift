import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif

extension URLSession: ModelLoading {
    public func load<Model>(request: URLRequest) async throws -> Model where Model : Decodable {
        let (responseData, _) = try await data(for: request)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let model = try? decoder.decode(Model.self, from: responseData) {
            return model
        } else {
            let responseError = try decoder.decode(CheckRunResponseError.self, from: responseData)
            throw CheckRunError.responseError(responseError)
        }
    }
}

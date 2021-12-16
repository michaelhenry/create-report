import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
#if canImport(_Concurrency)
import _Concurrency
#endif

extension URLSession: ModelLoading {
    public func load<Model>(request: URLRequest, completion: @escaping ((Result<Model, Error>) -> Void)) where Model : Decodable {
        dataTask(with: request) { responseData, _, error in
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let data = responseData ?? Data()
                if let model = try? decoder.decode(Model.self, from: data) {
                    completion(.success(model))
                } else {
                    let responseError = try decoder.decode(CheckRunResponseError.self, from: data)
                    completion(.failure(CheckRunError.responseError(responseError)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol ModelLoading {
    func load<Model>(request: URLRequest, completion: @escaping((Result<Model, Error>) -> Void)) where Model : Decodable
}

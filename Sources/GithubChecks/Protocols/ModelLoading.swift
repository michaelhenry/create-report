import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol ModelLoading {
    func load<Model>(request: URLRequest) async throws -> Model where Model : Decodable
}

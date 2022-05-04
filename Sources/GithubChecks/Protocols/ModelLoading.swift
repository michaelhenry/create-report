import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public protocol ModelLoading {
    func load<Model>(request: URLRequest, decoder: Decoder) async throws -> Model where Model: Decodable
}

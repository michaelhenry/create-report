import Foundation

public protocol Decoder {
    func decode<Model>(_ type: Model.Type, from data: Data) throws -> Model where Model: Decodable
}

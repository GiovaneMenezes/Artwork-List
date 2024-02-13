import Foundation

public struct DefaultResponse<T: Decodable>: Decodable {
    public let data: T
}

import Foundation

public struct Pagination: Decodable {
    public var currentPage: Int
    public var totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

public struct Page<T: Decodable>: Decodable {
    public let pagination: Pagination
    public let data: [T]
}

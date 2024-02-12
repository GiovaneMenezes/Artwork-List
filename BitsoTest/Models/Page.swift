import BitsoNetworking

struct Pagination {
    var currentPage: Int
    var totalPages: Int
}

extension Pagination {
    init(pagination: BitsoNetworking.Pagination) {
        self.totalPages = pagination.totalPages
        self.currentPage = pagination.currentPage
    }
}

struct Page<T> {
    let pagination: Pagination
    let data: [T]
}

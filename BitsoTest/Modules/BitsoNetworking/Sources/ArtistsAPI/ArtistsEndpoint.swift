import BitsoNetworking
import Foundation

enum ArtistsEndpoint {
    case getAuthor(id: Int)
}

extension ArtistsEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://api.artic.edu/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .getAuthor(let id):
            return "artists/\(id)"
        }
    }
    
    var method: BitsoNetworking.Method {
        switch self {
        case .getAuthor:
            return .get
        }
    }
    
    var task: BitsoNetworking.Task {
        switch self {
        case .getAuthor:
            return .plainRequest
        }
    }
}

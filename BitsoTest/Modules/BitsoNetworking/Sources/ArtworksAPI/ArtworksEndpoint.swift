import BitsoNetworking
import Foundation

enum ArtworksEndpoint {
    case getPage(page: Int)
}

extension ArtworksEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://api.artic.edu/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .getPage:
            return "artworks"
        }
    }
    
    var method: BitsoNetworking.Method {
        switch self {
        case .getPage:
            return .get
        }
    }
    
    var task: BitsoNetworking.Task {
        switch self {
        case .getPage(let page):
            return .requestQueryParameters(["page":page])
        }
    }
}

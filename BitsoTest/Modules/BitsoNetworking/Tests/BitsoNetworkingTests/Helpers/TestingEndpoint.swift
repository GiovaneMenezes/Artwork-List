@testable import BitsoNetworking
import Foundation

enum TestingEndpoint {
    case requestQueryParameters
}

extension TestingEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://www.justatest.com/")!
    }
    
    var path: String {
        switch self {
        case .requestQueryParameters:
            return "requestQueryParameters"
        }
    }
    
    var method: BitsoNetworking.Method {
        return .get
    }
    
    var task: BitsoNetworking.Task {
        switch self {
        case .requestQueryParameters:
            let dictionary: [String:Encodable] = [
                "integer":321,
                "string":"String",
                "boolean":false
            ]
            return .requestQueryParameters(dictionary)
        }
    }
    
    
}

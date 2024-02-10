import Foundation

public protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var method: Method { get }
    var task: Task { get }
}

extension Endpoint {
    func urlRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        switch task {
        case .requestQueryParameters(let dictionary):
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let parameters: [URLQueryItem] = dictionary.keys.sorted().map { key in
                return URLQueryItem(name: key, value: (dictionary[key] as? LosslessStringConvertible)?.description)
            }
            components?.queryItems = parameters
            urlRequest.url = components?.url
        case .plainRequest:
            break
        }
        
        return urlRequest
    }
}

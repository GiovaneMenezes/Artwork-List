import Foundation

public enum Task {
    //case requestBodyParameters(Encodable)
    case requestQueryParameters([String:Any])
    case plainRequest
}

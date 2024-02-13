import Foundation

enum ErrorExample: LocalizedError {
    case example1
    
    var errorDescription: String? {
        switch self {
        case .example1:
            return "Example 1"
        }
    }
}

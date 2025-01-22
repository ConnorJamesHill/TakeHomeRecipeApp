// This handles varrying errors to make it more likely that it can be better understood what exactly has gone wrong. This is just kind of a nice file to have to handle basic errors found when making api calls etc. We are conforming to localized error so that the error messages are user more friendly

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case invalidURL           // the URL is messed up
    case invalidResponse      // the response is messed up
    case decodingError       // JSON parsing messed up
    case serverError(Int)    // server messed up or is giving some error
    case unknown(Error)      // basically the default error for when none of the other errors are the issue.
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse),
             (.decodingError, .decodingError):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

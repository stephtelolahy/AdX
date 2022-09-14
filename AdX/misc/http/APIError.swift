//
//  APIError.swift
//  AdX
//
//  Created by TELOLAHY Hugues Stéphano on 14/09/2022.
//

import Foundation

enum APIError: Swift.Error {
    case invalidURL
    case httpCode(HTTPCode)
    case unexpectedResponse
    case imageDeserialization
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
            
        case let .httpCode(code):
            return "Unexpected HTTP code: \(code)"
            
        case .unexpectedResponse:
            return "Unexpected response from the server"
            
        case .imageDeserialization:
            return "Cannot deserialize image from Data"
        }
    }
}

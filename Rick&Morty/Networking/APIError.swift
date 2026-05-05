//
//  APIError.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

enum APIError: Error, LocalizedError, Sendable {
    case invalidURL
    case transport(URLError)
    case server(statusCode: Int)
    case decoding(DecodingError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL was invalid."
        case .transport(let error):
            return error.localizedDescription
        case .server(let code):
            return "Server returned status code \(code)."
        case .decoding:
            return "Failed to decode the server response."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

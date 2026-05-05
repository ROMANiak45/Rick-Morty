//
//  APIClient.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

/// Generic transport abstraction so feature services don't depend on `URLSession` directly.
protocol APIClient: Sendable {
    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> Response
}

/// Default `APIClient` backed by `URLSession`.
struct URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(baseURL: URL = URLSessionAPIClient.defaultBaseURL,
         session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func send<Response: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> Response {
        guard let url = endpoint.url(relativeTo: baseURL) else {
            throw APIError.invalidURL
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(from: url)
        } catch let urlError as URLError {
            throw APIError.transport(urlError)
        } catch {
            throw APIError.unknown(error)
        }

        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw APIError.server(statusCode: http.statusCode)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decoding(decodingError)
        } catch {
            throw APIError.unknown(error)
        }
    }

    static let defaultBaseURL: URL = URL(string: "https://rickandmortyapi.com/api/")!
}

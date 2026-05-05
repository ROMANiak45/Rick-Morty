//
//  Endpoint.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

/// Type-safe description of a Rick & Morty API endpoint.
struct Endpoint: Sendable {
    let path: String
    let queryItems: [URLQueryItem]

    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }

    func url(relativeTo base: URL) -> URL? {
        guard var components = URLComponents(url: base.appendingPathComponent(path),
                                             resolvingAgainstBaseURL: false) else {
            return nil
        }
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url
    }
}

extension Endpoint {
    static func characters(page: Int? = nil) -> Endpoint {
        Endpoint(path: "character", queryItems: Self.pageQuery(page))
    }

    static func character(id: Int) -> Endpoint {
        Endpoint(path: "character/\(id)")
    }

    static func locations(page: Int? = nil) -> Endpoint {
        Endpoint(path: "location", queryItems: Self.pageQuery(page))
    }

    static func location(id: Int) -> Endpoint {
        Endpoint(path: "location/\(id)")
    }

    static func episodes(page: Int? = nil) -> Endpoint {
        Endpoint(path: "episode", queryItems: Self.pageQuery(page))
    }

    static func episode(id: Int) -> Endpoint {
        Endpoint(path: "episode/\(id)")
    }

    private static func pageQuery(_ page: Int?) -> [URLQueryItem] {
        guard let page else { return [] }
        return [URLQueryItem(name: "page", value: String(page))]
    }
}

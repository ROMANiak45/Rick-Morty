//
//  PagedResponse.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

/// Wrapper for any paginated list endpoint returned by the Rick & Morty API.
nonisolated struct PagedResponse<Item: Decodable & Sendable>: Decodable, Sendable {
    let info: PageInfo
    let results: [Item]
}

nonisolated struct PageInfo: Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

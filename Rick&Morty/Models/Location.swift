//
//  Location.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

nonisolated struct Location: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    let url: URL?
    let created: Date?
}

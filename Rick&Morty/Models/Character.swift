//
//  Character.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

nonisolated struct Character: Identifiable, Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: Reference
    let location: Reference
    let image: URL?
    let episode: [URL]
    let url: URL?
    let created: Date?

    nonisolated enum Status: String, Decodable, Sendable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }

    nonisolated enum Gender: String, Decodable, Sendable {
        case female = "Female"
        case male = "Male"
        case genderless = "Genderless"
        case unknown
    }

    /// Lightweight reference used for `origin` and `location` on a character.
    /// `url` is empty when the API doesn't have a concrete linked resource.
    nonisolated struct Reference: Decodable, Hashable, Sendable {
        let name: String
        let url: String
    }
}

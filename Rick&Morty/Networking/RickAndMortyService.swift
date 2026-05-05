//
//  RickAndMortyService.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

/// High-level, domain-shaped facade over the Rick & Morty API. Views/view models
/// depend on this protocol so they can be unit-tested with a mock implementation.
protocol RickAndMortyService: Sendable {
    func fetchCharacters(page: Int?) async throws -> PagedResponse<Character>
    func fetchCharacter(id: Int) async throws -> Character

    func fetchLocations(page: Int?) async throws -> PagedResponse<Location>
    func fetchLocation(id: Int) async throws -> Location

    func fetchEpisodes(page: Int?) async throws -> PagedResponse<Episode>
    func fetchEpisode(id: Int) async throws -> Episode
}

extension RickAndMortyService {
    func fetchCharacters() async throws -> PagedResponse<Character> {
        try await fetchCharacters(page: nil)
    }
    func fetchLocations() async throws -> PagedResponse<Location> {
        try await fetchLocations(page: nil)
    }
    func fetchEpisodes() async throws -> PagedResponse<Episode> {
        try await fetchEpisodes(page: nil)
    }
}

struct LiveRickAndMortyService: RickAndMortyService {
    private let client: APIClient

    init(client: APIClient = URLSessionAPIClient()) {
        self.client = client
    }

    func fetchCharacters(page: Int?) async throws -> PagedResponse<Character> {
        try await client.send(.characters(page: page))
    }

    func fetchCharacter(id: Int) async throws -> Character {
        try await client.send(.character(id: id))
    }

    func fetchLocations(page: Int?) async throws -> PagedResponse<Location> {
        try await client.send(.locations(page: page))
    }

    func fetchLocation(id: Int) async throws -> Location {
        try await client.send(.location(id: id))
    }

    func fetchEpisodes(page: Int?) async throws -> PagedResponse<Episode> {
        try await client.send(.episodes(page: page))
    }

    func fetchEpisode(id: Int) async throws -> Episode {
        try await client.send(.episode(id: id))
    }
}

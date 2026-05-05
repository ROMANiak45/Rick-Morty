//
//  EpisodesListViewModel.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation
import Observation

@Observable
final class EpisodesListViewModel {
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var episodes: [Episode] = []
    private(set) var state: LoadState = .idle

    private let service: any RickAndMortyService

    init(service: any RickAndMortyService) {
        self.service = service
    }

    func loadIfNeeded() async {
        guard case .idle = state else { return }
        await load()
    }

    func load() async {
        state = .loading
        do {
            let response = try await service.fetchEpisodes()
            episodes = response.results
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}

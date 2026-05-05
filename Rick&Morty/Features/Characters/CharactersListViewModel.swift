//
//  CharactersListViewModel.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation
import Observation

@Observable
final class CharactersListViewModel: CharactersListViewModelProtocol {

    private(set) var characters: [Character] = []
    private(set) var initialPhase: CharactersListInitialPhase = .idle
    private(set) var pageLoadPhase: CharactersListPageLoadPhase = .idle
    private(set) var hasMore: Bool = true

    private var nextPage: Int = 1
    private let service: any RickAndMortyService

    init(service: any RickAndMortyService) {
        self.service = service
    }

    // MARK: - Public API used by the view

    /// Called the first time the view appears. No-op once we've already kicked off a load.
    func loadInitialIfNeeded() async {
        guard case .idle = initialPhase else { return }
        await loadInitial()
    }

    /// Pull-to-refresh. Resets pagination but keeps existing rows visible until
    /// the new page-1 response arrives, so the list doesn't flash empty.
    func refresh() async {
        do {
            let response = try await fetchPage(1)
            characters = response.results
            applyPageInfo(response.info, justLoadedPage: 1)
            initialPhase = .loaded
            pageLoadPhase = .idle
        } catch {
            // Surface as full-screen error only when we have nothing to show.
            if characters.isEmpty {
                initialPhase = .failed(error.localizedDescription)
            }
        }
    }

    /// Triggered from the UI when the last visible row appears.
    func loadNextPageIfNeeded() async {
        guard initialPhase == .loaded,
              hasMore,
              pageLoadPhase == .idle else { return }
        await loadNextPage()
    }

    /// Retry button on the full-screen error state.
    func retryInitial() async {
        await loadInitial()
    }

    /// Retry button on the in-list error footer.
    func retryNextPage() async {
        guard case .failed = pageLoadPhase else { return }
        await loadNextPage()
    }

    // MARK: - Internals

    private func loadInitial() async {
        initialPhase = .loading
        characters = []
        nextPage = 1
        hasMore = true
        pageLoadPhase = .idle

        do {
            let response = try await fetchPage(1)
            characters = response.results
            applyPageInfo(response.info, justLoadedPage: 1)
            initialPhase = .loaded
        } catch {
            initialPhase = .failed(error.localizedDescription)
        }
    }

    private func loadNextPage() async {
        let page = nextPage
        pageLoadPhase = .loading
        do {
            let response = try await fetchPage(page)
            characters.append(contentsOf: response.results)
            applyPageInfo(response.info, justLoadedPage: page)
            pageLoadPhase = .idle
        } catch {
            pageLoadPhase = .failed(error.localizedDescription)
        }
    }

    private func fetchPage(_ page: Int) async throws -> PagedResponse<Character> {
        let service = self.service
        return try await Retry.run {
            try await service.fetchCharacters(page: page)
        }
    }

    private func applyPageInfo(_ info: PageInfo, justLoadedPage: Int) {
        nextPage = justLoadedPage + 1
        hasMore = info.next != nil && justLoadedPage < info.pages
    }
}

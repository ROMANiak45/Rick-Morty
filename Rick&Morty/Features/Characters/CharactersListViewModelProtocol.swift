//
//  CharactersListViewModelProtocol.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation
import Observation

enum CharactersListInitialPhase: Equatable, Sendable {
    case idle
    case loading
    case loaded
    case failed(String)
}

enum CharactersListPageLoadPhase: Equatable, Sendable {
    case idle
    case loading
    case failed(String)
}

/// Everything `CharactersListView` needs from a view model. By coding the
/// view against this protocol instead of the concrete `CharactersListViewModel`
/// we can swap in mocks for previews and tests, or alternative implementations.
///
/// `Observable` is required so SwiftUI's change tracking still works through
/// the generic; `AnyObject` keeps it a reference type (matches `@Observable`).
/// `@MainActor` mirrors the project-wide default isolation and makes it safe
/// for the view to read properties / invoke methods directly from `body`.
@MainActor
protocol CharactersListViewModelProtocol: AnyObject, Observable {
    var characters: [Character] { get }
    var initialPhase: CharactersListInitialPhase { get }
    var pageLoadPhase: CharactersListPageLoadPhase { get }
    var hasMore: Bool { get }

    func loadInitialIfNeeded() async
    func refresh() async
    func loadNextPageIfNeeded() async
    func retryInitial() async
    func retryNextPage() async
}

//
//  CharactersListView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct CharactersListView<ViewModel: CharactersListViewModelProtocol>: View {
    @State var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Characters")
                .task { await viewModel.loadInitialIfNeeded() }
                .refreshable { await viewModel.refresh() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.characters.isEmpty {
            emptyState
        } else {
            populatedList
        }
    }

    // MARK: - Empty / loading / error states

    @ViewBuilder
    private var emptyState: some View {
        switch viewModel.initialPhase {
        case .idle, .loading:
            ProgressView().controlSize(.large)
        case .failed(let message):
            ContentUnavailableView {
                Label("Couldn't load characters", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Retry") {
                    Task { await viewModel.retryInitial() }
                }
                .buttonStyle(.borderedProminent)
            }
        case .loaded:
            ContentUnavailableView("No characters",
                                   systemImage: "person.slash",
                                   description: Text("Pull to refresh."))
        }
    }

    // MARK: - Populated list with pagination

    private var populatedList: some View {
        List {
            ForEach(viewModel.characters) { character in
                NavigationLink(value: character) {
                    CharacterRow(character: character)
                }
                .onAppear {
                    if character.id == viewModel.characters.last?.id {
                        Task { await viewModel.loadNextPageIfNeeded() }
                    }
                }
            }

            paginationFooter
        }
        .navigationDestination(for: Character.self) { character in
            CharacterDetailView(character: character)
        }
    }

    @ViewBuilder
    private var paginationFooter: some View {
        switch viewModel.pageLoadPhase {
        case .idle:
            EmptyView()
        case .loading:
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .listRowSeparator(.hidden)
        case .failed(let message):
            VStack(spacing: 8) {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    Task { await viewModel.retryNextPage() }
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
        }
    }
}

// MARK: - Row

private struct CharacterRow: View {
    let character: Character

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: character.image) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(character.name).font(.headline)
                Text("\(character.species) · \(character.status.rawValue.capitalized)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CharactersListView(viewModel: CharactersListViewModel(service: LiveRickAndMortyService()))
}

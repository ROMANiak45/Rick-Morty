//
//  EpisodesListView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct EpisodesListView: View {
    @State var viewModel: EpisodesListViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Episodes")
                .task { await viewModel.loadIfNeeded() }
                .refreshable { await viewModel.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.episodes.isEmpty {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView().controlSize(.large)
            case .failed(let message):
                ContentUnavailableView("Couldn't load episodes",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text(message))
            case .loaded:
                ContentUnavailableView("No episodes",
                                       systemImage: "tv.slash",
                                       description: Text("Pull to refresh."))
            }
        } else {
            List(viewModel.episodes) { episode in
                NavigationLink(value: episode) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(episode.name).font(.headline)
                        Text("\(episode.episode) · \(episode.airDate)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationDestination(for: Episode.self) { episode in
                EpisodeDetailView(episode: episode)
            }
        }
    }
}

#Preview {
    EpisodesListView(viewModel: EpisodesListViewModel(service: LiveRickAndMortyService()))
}

//
//  LocationsListView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct LocationsListView: View {
    @State var viewModel: LocationsListViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Locations")
                .task { await viewModel.loadIfNeeded() }
                .refreshable { await viewModel.load() }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.locations.isEmpty {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView().controlSize(.large)
            case .failed(let message):
                ContentUnavailableView("Couldn't load locations",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text(message))
            case .loaded:
                ContentUnavailableView("No locations",
                                       systemImage: "globe",
                                       description: Text("Pull to refresh."))
            }
        } else {
            List(viewModel.locations) { location in
                NavigationLink(value: location) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(location.name).font(.headline)
                        Text("\(location.type) · \(location.dimension)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationDestination(for: Location.self) { location in
                LocationDetailView(location: location)
            }
        }
    }
}

#Preview {
    LocationsListView(viewModel: LocationsListViewModel(service: LiveRickAndMortyService()))
}

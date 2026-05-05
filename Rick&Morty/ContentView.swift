//
//  ContentView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct ContentView: View {
    let service: any RickAndMortyService

    var body: some View {
        TabView {
            CharactersListView(viewModel: CharactersListViewModel(service: service))
                .tabItem { Label("Characters", systemImage: "person.2") }

            LocationsListView(viewModel: LocationsListViewModel(service: service))
                .tabItem { Label("Locations", systemImage: "globe") }

            EpisodesListView(viewModel: EpisodesListViewModel(service: service))
                .tabItem { Label("Episodes", systemImage: "tv") }
        }
    }
}

#Preview {
    ContentView(service: LiveRickAndMortyService())
}

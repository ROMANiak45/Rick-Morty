//
//  EpisodeDetailView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode

    var body: some View {
        // Placeholder detail view — real layout to be added later.
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name).font(.title2).bold()
            Text("Code: \(episode.episode)").foregroundStyle(.secondary)
            Text("Aired: \(episode.airDate)").foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle(episode.episode)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EpisodeDetailView(episode: Episode(id: 1,
                                           name: "Pilot",
                                           airDate: "December 2, 2013",
                                           episode: "S01E01",
                                           characters: [],
                                           url: nil,
                                           created: nil) )
    }
}

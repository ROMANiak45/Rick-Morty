//
//  CharacterDetailView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct CharacterDetailView: View {
    let character: Character

    var body: some View {
        // Placeholder detail view — real layout to be added later.
        VStack(spacing: 12) {
            CachedAsyncImage(url: character.image) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Color.secondary.opacity(0.2)
            }
            .frame(maxWidth: 240, maxHeight: 240)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(character.name).font(.title2).bold()
            Text(character.species).foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CharacterDetailView(character: Character(id: 1,
                                                 name: "Rick Sanchez",
                                                 status: .alive,
                                                 species: "Human",
                                                 type: "",
                                                 gender: .male,
                                                 origin: .init(name: "Earth (C-137)", url: ""),
                                                 location: .init(name: "Earth (C-137)", url: ""),
                                                 image: nil,
                                                 episode: [],
                                                 url: nil,
                                                 created: nil) )
    }
}

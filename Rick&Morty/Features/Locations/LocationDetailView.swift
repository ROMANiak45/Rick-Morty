//
//  LocationDetailView.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

struct LocationDetailView: View {
    let location: Location

    var body: some View {
        // Placeholder detail view — real layout to be added later.
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name).font(.title2).bold()
            Text("Type: \(location.type)").foregroundStyle(.secondary)
            Text("Dimension: \(location.dimension)").foregroundStyle(.secondary)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        LocationDetailView(location: Location(id: 1,
                                              name: "Earth (C-137)",
                                              type: "Planet",
                                              dimension: "Dimension C-137",
                                              residents: [],
                                              url: nil,
                                              created: nil) )
    }
}

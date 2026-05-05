//
//  CachedAsyncImage.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI
import UIKit

/// `AsyncImage`-style view that loads through `ImageCache.shared`,
/// so the same URL is fetched once across the whole app.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    init(url: URL?,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) { await load() }
    }

    private func load() async {
        guard let url else {
            uiImage = nil
            return
        }
        do {
            let loaded = try await ImageCache.shared.image(for: url)
            guard !Task.isCancelled else { return }
            uiImage = loaded
        } catch {
            // Placeholder remains visible on failure.
        }
    }
}

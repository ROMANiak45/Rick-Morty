//
//  ImageCache.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation
import UIKit

/// Two-tier image cache:
///   - in-memory `NSCache<NSURL, UIImage>` (auto-evicted on memory pressure)
///   - HTTP-level `URLCache` on disk via a dedicated `URLSession`
/// Concurrent requests for the same URL are deduplicated through `inFlight`.
actor ImageCache {
    static let shared = ImageCache()

    enum ImageCacheError: Error, Sendable {
        case invalidImageData
    }

    private let memory: NSCache<NSURL, UIImage>
    private let session: URLSession
    private var inFlight: [URL: Task<UIImage, Error>] = [:]

    init(memoryCountLimit: Int = 200,
         memoryByteLimit: Int = 50 * 1024 * 1024,        // 50 MB
         diskByteLimit: Int = 200 * 1024 * 1024) {       // 200 MB
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = memoryCountLimit
        cache.totalCostLimit = memoryByteLimit
        self.memory = cache

        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: memoryByteLimit,
                                   diskCapacity: diskByteLimit,
                                   diskPath: "rm-image-cache")
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }

    func image(for url: URL) async throws -> UIImage {
        if let cached = memory.object(forKey: url as NSURL) {
            return cached
        }

        if let task = inFlight[url] {
            return try await task.value
        }

        let session = self.session
        let task = Task<UIImage, Error> {
            let (data, _) = try await session.data(from: url)
            guard let image = UIImage(data: data) else {
                throw ImageCacheError.invalidImageData
            }
            return image
        }
        inFlight[url] = task

        do {
            let image = try await task.value
            memory.setObject(image, forKey: url as NSURL, cost: estimatedCost(for: image))
            inFlight[url] = nil
            return image
        } catch {
            inFlight[url] = nil
            throw error
        }
    }

    /// Best-effort decoded byte estimate (RGBA assumption). Used as `NSCache` cost.
    private func estimatedCost(for image: UIImage) -> Int {
        let pixels = Int(image.size.width * image.scale) * Int(image.size.height * image.scale)
        return pixels * 4
    }
}

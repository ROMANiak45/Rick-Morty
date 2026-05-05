//
//  Retry.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import Foundation

/// Lightweight retry helper. Retries `operation` up to `attempts` times with
/// exponential backoff, but only for errors classified as transient.
enum Retry {
    static func run<T>(
        attempts: Int = 3,
        initialBackoff: Duration = .milliseconds(300),
        operation: () async throws -> T
    ) async throws -> T where T: Sendable {
        precondition(attempts >= 1, "Retry requires at least one attempt")

        var attempt = 1
        while true {
            do {
                return try await operation()
            } catch {
                guard attempt < attempts,
                      !Task.isCancelled,
                      isRetryable(error) else {
                    throw error
                }
                let backoff = initialBackoff * (1 << (attempt - 1))
                try? await Task.sleep(for: backoff)
                attempt += 1
            }
        }
    }

    /// Heuristic: only retry for errors that are likely to succeed on a second try.
    /// Auth errors, decoding errors, 4xx (except 408/429) are *not* retried.
    private static func isRetryable(_ error: Error) -> Bool {
        if let apiError = error as? APIError {
            switch apiError {
            case .transport(let urlError):
                switch urlError.code {
                case .timedOut, .networkConnectionLost, .notConnectedToInternet,
                     .dnsLookupFailed, .cannotFindHost, .cannotConnectToHost,
                     .resourceUnavailable:
                    return true
                default:
                    return false
                }
            case .server(let code):
                return code == 408 || code == 429 || (500...599).contains(code)
            case .invalidURL, .decoding, .unknown:
                return false
            }
        }
        return false
    }
}

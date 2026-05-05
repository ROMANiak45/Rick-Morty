//
//  Rick_MortyApp.swift
//  Rick&Morty
//
//  Created by Roman Croitor on 05.05.2026.
//

import SwiftUI

@main
struct Rick_MortyApp: App {
    private let service: any RickAndMortyService = LiveRickAndMortyService()

    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
        }
    }
}

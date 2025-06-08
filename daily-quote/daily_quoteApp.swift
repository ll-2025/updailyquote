//
//  daily_quoteApp.swift
//  daily-quote
//
//  Created by lb on 4/13/25.
//

import SwiftUI

@main
struct daily_quoteApp: App {
    @StateObject private var quoteViewModel = QuoteViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quoteViewModel)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                // Save any pending changes when app moves to background
                quoteViewModel.saveFavorites()
            }
        }
    }
}

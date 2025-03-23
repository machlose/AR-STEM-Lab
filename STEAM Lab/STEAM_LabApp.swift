//
//  STEAM_LabApp.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

@main
struct STEAM_LabApp: App {
    @StateObject private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .colorScheme(.dark)
                .environmentObject(appState)
                .colorScheme(.dark)
        }
    }
}

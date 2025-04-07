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
    @Environment(\.colorScheme) private var colorScheme
    var body: some Scene {
        WindowGroup {
            Group{
                if !appState.Experiment{
                    ContentView()
                        .environmentObject(appState)
                        .preferredColorScheme(appState.Theme)
                }
                else{
                    SolarView(reset: $appState.Experiment)
                }
            }
            .onAppear{
                appState.Theme = colorScheme
                appState.checkSavedColorScheme()
            }
        }
    }
}

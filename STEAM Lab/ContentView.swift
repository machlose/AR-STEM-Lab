//
//  ContentView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State public var currentView: Categories = .experiments
    var body: some View {
        switch currentView {
        case .profile:
            ProfileView()
                .preferredColorScheme(appState.Theme)
        case .experiments:
            ExperimentNavigationView()
                .preferredColorScheme(appState.Theme)
        }
        if !appState.isFullScreen{
            CategoryBarView(currentView: $currentView)
                .preferredColorScheme(appState.Theme)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

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
    @State private var boom: Double = 0.0
    var body: some View {
        switch currentView {
        case .profile:
            ProfileView()
        case .experiments:
            ExperimentNavigationView()
        }
        if (appState.Experiment == nil){
            CategoryBarView(currentView: $currentView)
        }
    }
}

#Preview {
    @Previewable @StateObject var appState = AppState()
    ContentView()
        .environmentObject(appState)
        .preferredColorScheme(appState.Theme)
}

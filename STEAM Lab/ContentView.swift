//
//  ContentView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var systemColorScheme
    @State public var currentView: Categories = .experiments
    var body: some View {
        VStack{
            switch currentView {
            case .profile:
                ProfileView()
            case .experiments:
                ExperimentNavigationView()
            }
            if !appState.isFullScreen{
                CategoryBarView(currentView: $currentView)
            }
        }
        .environment(\.colorScheme, appState.colorScheme ?? systemColorScheme)
    }
    
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}

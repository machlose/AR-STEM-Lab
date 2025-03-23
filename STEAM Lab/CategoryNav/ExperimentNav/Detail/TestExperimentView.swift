//
//  TestExperimentView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct TestExperimentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .onAppear{
            appState.isFullScreen = true
        }
        .onDisappear{
            appState.isFullScreen = false
        }
    }
}

#Preview {
    TestExperimentView().environmentObject(AppState())
}

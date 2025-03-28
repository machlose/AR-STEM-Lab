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
        SolarView()
        .onAppear{
            appState.isFullScreen = true
        }
        .onDisappear{
            withAnimation(Animation.easeIn(duration: 0.1)){
                appState.isFullScreen = false
            }
        }
    }
}

#Preview {
    TestExperimentView().environmentObject(AppState())
}

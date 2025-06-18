//
//  MathView.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 07/04/2025.
//

import SwiftUI

struct MathView: View {
    @EnvironmentObject private var appState: AppState
    var body: some View {
        ZStack {
            MathARViewContainer()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Button{
                    appState.Experiment = nil
                }
                label:{
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var appState = AppState()
        MathView()
            .environmentObject(appState)
    }
}



//
//  ProfileView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Form{
            VStack{
                Text("Profil Użytkownika:")
                    .font(.title2)
                    .bold()
                Picker("preferowany Motyw", selection: $appState.colorScheme){
                    Text("Domyślny").tag(ColorScheme?.none)
                    Text("Ciemny").tag(ColorScheme.dark)
                    Text("Jasny").tag(ColorScheme.light)
                }
            }
        }
        .preferredColorScheme(appState.colorScheme)
        .onChange(of: appState.colorScheme, {
            appState.setTheme(colorScheme: appState.colorScheme)
        })
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}

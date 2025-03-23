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
                Picker("preferowany Motyw", selection: $appState.userProfile.preferedTheme){
                    Text("Ciemny").tag(Themes.dark)
                    Text("Jasny").tag(Themes.light)
                }
            }
        }
        .onChange(of: appState.userProfile.preferedTheme, {
            UserDefaults.setObject(data: appState.userProfile)
            appState.Theme = (appState.userProfile.preferedTheme == .dark) ? ColorScheme.dark : ColorScheme.light
        })
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}

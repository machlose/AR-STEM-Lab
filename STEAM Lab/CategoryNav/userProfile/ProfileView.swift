//
//  ProfileView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var userProfile: UserProfile = UserDefaults.getObject(forKey: "profile") ?? UserProfile()
    var body: some View {
        Form{
            VStack{
                Text("Profil Użytkownika:")
                    .font(.title2)
                    .bold()
                Picker("preferowany Motyw", selection: $userProfile.preferedTheme){
                    Text("Ciemny").tag(Themes.dark)
                    Text("Jasny").tag(Themes.light)
                }
            }
        }
        .onChange(of: [userProfile.preferedTheme], {
            UserDefaults.setObject(data: userProfile)
        })
    }
}

#Preview {
    ProfileView()
}

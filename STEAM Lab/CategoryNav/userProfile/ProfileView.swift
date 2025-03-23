//
//  ProfileView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct ProfileView: View {
    
    //do zmiany w wolnej chwili
    @ObservedObject private var userProfile = (try? JSONDecoder().decode(UserProfile.self, from: (UserDefaults.standard.object(forKey: "profile") as? Data ?? Data()))) ?? UserProfile()
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
            try? UserDefaults.standard.set(JSONEncoder().encode(userProfile),forKey: "profile")
        })
    }
}

#Preview {
    ProfileView()
}

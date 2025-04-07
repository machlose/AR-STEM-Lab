//
//  EnviromentObject.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var Experiment: Bool = false
    @Published var Theme: ColorScheme
    @Published var userProfile: UserProfile
    init(){
        userProfile = UserDefaults.getObject(forKey: "profile") ?? UserProfile()
        
        @Environment(\.colorScheme) var colorScheme
        Theme = colorScheme
        if(userProfile.preferedTheme != nil){
            self.Theme = (userProfile.preferedTheme == .dark) ? ColorScheme.dark : ColorScheme.light
        }
    }
}

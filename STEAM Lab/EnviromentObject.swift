//
//  EnviromentObject.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var Experiment: Bool = false
    @Published var Theme: ColorScheme? = nil
    @Published var userProfile: UserProfile
    init(){
        userProfile = UserDefaults.getObject(forKey: "profile") ?? UserProfile()
    }
    func checkSavedColorScheme(){
        if(userProfile.preferedTheme != nil){
            self.Theme = (userProfile.preferedTheme == .dark) ? ColorScheme.dark : ColorScheme.light
        }
        else{
            userProfile.preferedTheme = (Theme == ColorScheme.dark) ? Themes.dark : Themes.light
        }
    }
}

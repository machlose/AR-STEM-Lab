//
//  EnviromentObject.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isFullScreen: Bool = false
    @AppStorage("selectedTheme") private var storedTheme: String = "system"
    @Published var colorScheme: ColorScheme? = nil
    
    init(){
        loadTheme()
    }
    
    func loadTheme(){
        switch storedTheme{
        case "light":
            colorScheme = .light
        case "dark":
            colorScheme = .dark
        default:
            colorScheme = nil
        }
    }
    
    func setTheme(colorScheme: ColorScheme?){
        self.colorScheme = colorScheme
        self.storedTheme = colorScheme == .dark ? "dark" : colorScheme == .light ? "light" : "system"
    }
}

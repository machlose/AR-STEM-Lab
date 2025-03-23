//
//  UserProfile.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//
import SwiftUI


class UserProfile: Codable, ObservableObject{
    @Published var preferedTheme: Themes
    
    init(preferedTheme: Themes = .light) {
        self.preferedTheme = preferedTheme
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        preferedTheme = try container.decode(Themes.self, forKey: .preferedTheme)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(preferedTheme,forKey: .preferedTheme)
    }
    
    enum CodingKeys:String, CodingKey{
        case preferedTheme;
    }
}
enum Themes: Codable{
    case dark, light;
}

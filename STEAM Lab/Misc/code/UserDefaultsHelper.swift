//
//  UserDefaultsHelper.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//
import SwiftUI

extension UserDefaults{
    static func setObject<T: Codable>(data: T){
        try? UserDefaults.standard.set(JSONEncoder().encode(data),forKey: "profile")
    }
    static func getObject<T: Codable>(forKey: String) -> T?{
        let fetchedProfile = UserDefaults.standard.object(forKey: "profile") as? Data ?? Data()
        return (try? JSONDecoder().decode(T.self, from: fetchedProfile))
    }
}

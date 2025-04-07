//
//  CategoryBar.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct CategoryBarView: View {
    @Binding var currentView: Categories
    let categoryButtons: [CategoryButton] = [
        CategoryButton(iconName: "flaskBase",category: .experiments,description: "Eksperymenty"),
        CategoryButton(iconName: "profile",category: .profile,description: "Profil")
    ]
    var body: some View {
        HStack{
            ForEach(categoryButtons){ button in
                CategoryButtonView(currentView: $currentView, data: button)
            }
            
        }
        .background(.background)
    }
}

#Preview {
//    CategoryBarView()
}


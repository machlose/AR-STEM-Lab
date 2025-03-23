//
//  CategoryButton.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct CategoryButtonView: View {
    @Binding var currentView: Categories
    let data : CategoryButton

    var body: some View {
        Button{
            withAnimation(Animation.easeIn(duration: 0.1)){
                currentView = data.category
            }
        }
        label:{
            VStack{
                Image(data.iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(data.description)
                    .foregroundStyle(.baseFont)
                    .bold()
            }
            .padding()
            .padding(.horizontal)
            .background((currentView == data.category) ? .experimentButton : .clear)
            .cornerRadius(15)
        }
    }
}
enum Categories {
    case profile, experiments;
}
struct CategoryButton: Identifiable{
    var id = UUID()
    var iconName: String
    var category: Categories
    var description: String
    
    init(iconName: String, category: Categories, description: String) {
        self.iconName = iconName
        self.category = category
        self.description = description
    }
}

#Preview {
//    CategoryButtonView(currentView: .profile, data: CategoryButton(iconName: "BiologyPlanet",category: .profile,description: "Profil"))
}

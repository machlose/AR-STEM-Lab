//
//  SubjectButton.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct SubjectButtonView: View {
    var data: SubjectButton
    var body: some View {
        HStack{
            VStack{
                Image(data.iconName)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
            }
            VStack(alignment: .leading){
                Text(data.subjectName)
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(Color.font)
                Text(data.subText)
                    .font(.footnote)
                    .foregroundStyle(Color.font.secondary)
            }
        }
        .padding()
        .background(data.bgColor)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.25), radius: 1, x:0, y: 2)
    }
}

struct SubjectButton: Identifiable{
    var id = UUID()
    var iconName: String
    var subjectName: String
    var subText: String
    var bgColor: Color
    public init(iconName: String, subjectName: String, subText: String, bgColor: Color) {
        self.iconName = iconName
        self.subjectName = subjectName
        self.subText = subText
        self.bgColor = bgColor
    }
}

#Preview {
    SubjectButtonView(data: SubjectButton(iconName: "logo", subjectName: "Chemia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow))
}

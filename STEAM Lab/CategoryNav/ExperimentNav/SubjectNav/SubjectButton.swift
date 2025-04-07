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
                    .frame(width: 75, height: 75)
                    .scaledToFit()
                    .shadow(color: .black.opacity(0.25), radius: 1, x:0, y: 2)
            }
            VStack(alignment: .leading){
                Text(data.subjectName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(Color.font)
                Text(data.subText)
                    .font(.footnote)
                    .foregroundStyle(Color.font.secondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: 400, alignment: .leading)
        }
        .padding()
        .background(Color(data.bgColor))
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.25), radius: 1, x:0, y: 2)
        .padding(.horizontal)
    }
}

struct SubjectButton: Identifiable, Hashable, Codable{
    
    var id = UUID()
    var iconName: String
    var subjectName: String
    var subText: String
    var bgColor: String
    public init(iconName: String, subjectName: String, subText: String, bgColor: String) {
        self.iconName = iconName
        self.subjectName = subjectName
        self.subText = subText
        self.bgColor = bgColor
    }
    enum CodingKeys: String, CodingKey{
        case iconName;
        case subjectName;
        case subText;
        case bgColor;
    }
}

#Preview {
    SubjectButtonView(data: SubjectButton(iconName: "ChemFlask", subjectName: "Chemia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: "ChemistryYellow"))
}

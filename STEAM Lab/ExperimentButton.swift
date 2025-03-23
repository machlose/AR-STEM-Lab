//
//  ExperimentButton.swift
//  STEAM Lab
//
//  Created by uczen on 22/03/2025.
//

import SwiftUI

struct ExperimentButtonView: View {
    var data: ExperimentButton
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(data.name)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.baseFont)
                Text(data.description)
                    .font(.footnote)
                    .foregroundStyle(.baseFont)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: 400, alignment: .leading)
            }
        }
        .padding()
        .background(.experimentButton)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.25), radius: 1, x:0, y: 2)
        .padding(.horizontal)
    }
}
struct ExperimentButton: Identifiable{
    var id = UUID()
    var name: String
    var description: String
    var detailedDescription: String
    var experimentView: AnyView
    init(name: String, description: String, detailedDescription: String, experimentView: AnyView) {
        self.name = name
        self.description = description
        self.detailedDescription = detailedDescription
        self.experimentView = experimentView
    }
}

#Preview {
    ExperimentButtonView(data: ExperimentButton(name:"Eksperyment", description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView())))
}

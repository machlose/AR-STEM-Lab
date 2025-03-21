//
//  ContentView.swift
//  STEM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    let buttonList: [SubjectButton] = [
        SubjectButton(iconName: "logo", subjectName: "Fizyka", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Chemia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Matematyka", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Biologia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow)
    ]
    var body: some View {
        VStack(){
            TitleSectionView()
                .padding()
            Divider()
                .padding(.horizontal)
            NavigationStack{
                ScrollView{
                    VStack(spacing:15){
                        ForEach(buttonList) { button in
                            NavigationLink{
                                SubjectView()
                                    .navigationTitle(button.subjectName)
                            } label:{
                                SubjectButtonView(data: button)
                            }
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

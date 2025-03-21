//
//  ContentView.swift
//  STEM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(){
            TitleSectionView()
                .padding()
            Divider()
                .padding(.horizontal)
            ScrollView{
                VStack(spacing:15){
                    ForEach(0..<4){_ in
                        SubjectButtonView(data: SubjectButton(iconName: "logo", subjectName: "Chemia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow))
                    }
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}

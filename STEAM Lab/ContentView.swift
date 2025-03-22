//
//  ContentView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TitleSectionView()
            Divider()
                .padding(.horizontal)
            NavigationSplitView(columnVisibility: .constant(.doubleColumn)){
                ScrollView{
                    VStack(spacing: 15){
                        ForEach(buttonList){ button in
                            NavigationLink{
                                SubjectView()
                                    .navigationTitle(button.subjectName)
                            } label:{
                                SubjectButtonView(data: button)
                            }
                        }
                    }
                    .navigationTitle("Dziedziny")
                }
                .padding()
            }detail:{
                Text("Wybierz dziedzinę")
                    .font(.largeTitle)
                    .bold()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

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
            NavigationStack{
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
                }
                .padding()
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

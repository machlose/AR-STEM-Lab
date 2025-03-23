//
//  ContentView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSubject: SubjectButton? = nil
    @State private var visibility: NavigationSplitViewVisibility = .doubleColumn
    var body: some View {
        VStack {
            NavigationSplitView(columnVisibility: $visibility){
            TitleSectionView()
            Divider()
                .padding(.horizontal)
                    VStack(spacing: 15){
                        List(buttonList, selection: $selectedSubject){ button in
                            NavigationLink(value:button,label:{
                                HStack{
                                    Spacer()
                                    SubjectButtonView(data: button)
                                    Spacer()
                                }
                            })
                            .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
            }detail:{
                if let selectedSubject {
                    SubjectView(subjectName: selectedSubject.subjectName)
                }
                else{
                    Text("Wybierz dziedzinę")
                        .font(.largeTitle)
                        .bold()
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

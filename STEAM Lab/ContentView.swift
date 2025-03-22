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
                // nie działa na iphone
                    VStack(spacing: 15){
                        List{
                            ForEach(buttonList){ button in
                                Button(){
                                    selectedSubject = button
                                    visibility = .detailOnly
                                    print(visibility)
                                }
                                label:{
                                    if UIDevice.current.userInterfaceIdiom == .pad{
                                        SubjectButtonView(data: button)
                                    }
                                    else{
                                        HStack{
                                            Spacer()
                                            SubjectButtonView(data: button)
                                            Spacer()
                                        }
                                    }
                                }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                }
                .padding()
            }detail:{
                if let selectedSubject {
                    SubjectView()
                }
                else{
                    Text("Wybierz dziedzinę")
                        .font(.largeTitle)
                        .bold()
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

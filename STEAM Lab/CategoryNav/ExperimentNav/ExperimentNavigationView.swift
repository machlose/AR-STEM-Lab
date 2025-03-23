//
//  ExperimentNavigationView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct ExperimentNavigationView: View {
    @State private var selectedSubject: SubjectButton? = nil
    @State private var visibility: NavigationSplitViewVisibility = .doubleColumn
    var body: some View {
        VStack {
            NavigationStack{
                TitleSectionView()
                Divider()
                    .padding(.horizontal)
                Text("Wybierz dziedzinę:")
                    .font(.largeTitle)
                    .foregroundStyle(.baseFont)
                    .bold()
                ScrollView{
                    VStack(spacing: 15){
                        ForEach(buttonList){ button in
                            NavigationLink(destination:SubjectView(subjectName: button.subjectName),label:{
                                SubjectButtonView(data: button)
                            })
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ExperimentNavigationView()
}

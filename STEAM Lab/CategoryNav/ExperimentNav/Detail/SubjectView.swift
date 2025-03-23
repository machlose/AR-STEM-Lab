//
//  SubjectView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct SubjectView: View {
    @EnvironmentObject var appState: AppState
    let subjectName: String
    let buttonList: [String: [ExperimentButton]] = [
        "Fizyka": [
            ExperimentButton(name:"Eksperyment Fizyka 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView())),
            ExperimentButton(name:"Eksperyment Fizyka 2",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView2())),
            ExperimentButton(name:"Eksperyment Fizyka 3",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView3())),
            ExperimentButton(name:"Eksperyment 4",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView()))
            ],
        "Chemia": [
            ExperimentButton(name:"Eksperyment Chemia 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView()))
            ],
        "Matematyka": [
            ExperimentButton(name:"Eksperyment Matematyka 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView()))
            ],
        "Biologia": [
            ExperimentButton(name:"Eksperyment Biologia 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView()))
            ]
        ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(buttonList[subjectName]!) { button in
                        NavigationLink{
                            ExperimentDetailView(SelectedExperiment: button)
                        } label:{
                            ExperimentButtonView(data: button)
                        }
                    }
                }
            }
        }
        .navigationTitle(subjectName)
        .onAppear{
            appState.isFullScreen = false
        }
    }
}

#Preview {
    SubjectView(subjectName: "Chemia")
}


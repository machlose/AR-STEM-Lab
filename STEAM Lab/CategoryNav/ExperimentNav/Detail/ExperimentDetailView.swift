//
//  ExperimentDetailView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct ExperimentDetailView: View {
    @EnvironmentObject var appState: AppState
    let SelectedExperiment: ExperimentButton
    var body: some View {
        NavigationStack{
            VStack{
                Text(SelectedExperiment.name)
                    .font(.title)
                    .bold()
                Text(SelectedExperiment.description)
                Divider()
                ScrollView{
                    VStack{
                        Text(SelectedExperiment.detailedDescription)
                        NavigationLink{
                            SelectedExperiment.experimentView
                        } label: {
                            StartButtonView(content: "Rozpocznij eksperyment")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ExperimentDetailView(SelectedExperiment: ExperimentButton(name:"Eksperyment Fizyka 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", detailedDescription: "Lorem ipsum dolor sit amet consectetur adipiscing elit", experimentView: AnyView(TestExperimentView())))
        .environmentObject(AppState())
}

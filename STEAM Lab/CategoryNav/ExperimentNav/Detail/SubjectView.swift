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
    let experimentList: [String: [ExperimentButton]] = [
        "Fizyka": [
            ExperimentButton(name:"Układ Słoneczny",description: "Poznaj Planety Układu słonecznego", detailedDescription: "Kliknij na planetę i zobacz informacje o niej", experimentView: .solar),
            ExperimentButton(name:"Ziemia i Księżyc",description: "Poznaj ziemię i księżyc", detailedDescription: "Kliknij na planetę i zobacz informacje o niej", experimentView: .solar),
            ExperimentButton(name:"Czarna dziura",description: "Poznaj wpływ czarnych dziur na planety dookoła", detailedDescription: "Kliknij na planetę i zobacz informacje o niej", experimentView: .solar),
            ExperimentButton(name:"Zabawa z grawitacją",description: "Stwórz swój własny układ planetarny", detailedDescription: "Kliknij na planetę i zobacz informacje o niej", experimentView: .solar)


            ],
        "Chemia": [],
        "Matematyka": [],
        "Biologia": []
        ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(experimentList[subjectName]!) { button in
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
    }
}
 
#Preview {
    SubjectView(subjectName: "Chemia")
        .environmentObject(AppState())
}

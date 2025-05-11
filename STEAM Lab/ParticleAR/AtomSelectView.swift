//
//  AtomSelect.swift
//  STEAM Lab
//
//  Created by uczen on 11/05/2025.
//

import SwiftUI
 
struct AtomSelectView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(Atoms) { atom in
                        NavigationLink{
//                            ExperimentDetailView(SelectedExperiment: )
                            TestExperimentView() // 
                        } label:{
                            ExperimentButtonView(data: ExperimentButton(name: atom.name,description: atom.description, detailedDescription: "", experimentView: AnyView(TestExperimentView())))
                        }
                    }
                }
            }
        }
        .navigationTitle("Wybierz atom")
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

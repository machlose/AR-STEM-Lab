//
//  SubjectView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct SubjectView: View {
    let buttonList: [ExperimentButton] = [
        ExperimentButton(name:"Eksperyment 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", destination: AnyView(TestExperimentView())),
        ExperimentButton(name:"Eksperyment 2",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", destination: AnyView(TestExperimentView2())),
        ExperimentButton(name:"Eksperyment 3",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", destination: AnyView(TestExperimentView3())),
        ExperimentButton(name:"Eksperyment 4",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit", destination: AnyView(TestExperimentView())),
    ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(buttonList) { button in
                        NavigationLink{
                            button.destination
                        } label:{
                            ExperimentButtonView(data: button)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SubjectView()
}


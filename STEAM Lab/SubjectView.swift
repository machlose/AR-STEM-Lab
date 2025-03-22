//
//  SubjectView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct SubjectView: View {
    let buttonList: [ExperimentButton] = [
        ExperimentButton(name:"Eksperyment 1",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit"),
        ExperimentButton(name:"Eksperyment 2",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit"),
        ExperimentButton(name:"Eksperyment 3",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit"),
        ExperimentButton(name:"Eksperyment 4",description: "Lorem ipsum dolor sit amet consectetur adipiscing elit"),
    ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(buttonList) { button in
                        NavigationLink{
                            SubjectView()
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


//
//  SubjectView.swift
//  STEM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct SubjectView: View {
    let buttonList: [SubjectButton] = [
        SubjectButton(iconName: "logo", subjectName: "Experyment 1", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Experyment 2", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Experyment 3", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
        SubjectButton(iconName: "logo", subjectName: "Experyment 4", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow)
    ]
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing:15){
                    ForEach(buttonList) { button in
                        NavigationLink{
                            SubjectView()
                        } label:{
                            SubjectButtonView(data: button)
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

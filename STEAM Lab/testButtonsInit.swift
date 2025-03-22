//
//  testButtonsInit.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//
import SwiftUI

let buttonList: [SubjectButton] = [
    SubjectButton(iconName: "PhysicsPlanet", subjectName: "Fizyka", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .physicsOrange),
    SubjectButton(iconName: "ChemFlask", subjectName: "Chemia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .chemistryYellow),
    SubjectButton(iconName: "MathCube", subjectName: "Matematyka", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .mathBlue),
    SubjectButton(iconName: "BiologyPlanet", subjectName: "Biologia", subText: "Lorem ipsum dolor sit amet consectetur adipiscing elit", bgColor: .biologyGreen)
]

#Preview{
    ContentView()
}

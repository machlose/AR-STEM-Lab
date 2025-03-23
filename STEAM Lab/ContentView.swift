//
//  ContentView.swift
//  STEAM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State public var currentView: Categories = .experiments
    var body: some View {
        switch currentView {
            case .profile:
                SubjectView(subjectName: "Fizyka")
            case .experiments:
                ExperimentNavigationView()
        }
        CategoryBarView(currentView: $currentView)
    }
}

#Preview {
    ContentView()
}

//
//  PickPlanetView.swift
//  SphereAR
//
//  Created by uczen on 28/03/2025.
//

import SwiftUI

struct PickPlanetView: View {
    @State private var show: Bool = false
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Kliknij w planetę aby ją wybrać")
                Spacer()
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20)
            .animation(Animation.easeInOut(duration:0.4),value: show)
            .onAppear{
                show = true
            }
            .onDisappear{
                show = false
            }
        }
    }
}

#Preview {
    PickPlanetView()
}

//
//  PickPlanetView.swift
//  SphereAR
//
//  Created by uczen on 28/03/2025.
//

import SwiftUI

struct PlanetSpeedSlider: View {
    @State private var offset: CGSize = CGSize(width: 0, height: -200)
    @Binding var show: Bool
    @Binding var value: Double
    var body: some View {
        OffsetWrapper(show: $show, offset: offset,invertState: false){
            VStack{
                Text("Prędkość obrotu planety")
                    .bold()
                HStack{
                    SliderView(forceUpdateOnChangeOf: $show, outValue: $value)
                }
            }
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20)
        }
        .offset(x:0,y:-70)
    }
}

#Preview {
    SolarView()
}

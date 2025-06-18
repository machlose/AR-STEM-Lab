//
//  ContentView.swift
//  SphereAR
//
//  Created by Rafał Michałowski on 20/03/2025.
//

import SwiftUI

struct SolarView: View {
    // Wybrana planeta – gdy nie jest nil, wyświetlamy overlay z informacjami
    @Binding var reset: Experiments?
    @State private var selectedPlanetInformation: PlanetInformation? = nil
    @State private var overlayShow: Bool = false
    @State private var speed: Double = 1

    var body: some View {
        ZStack {
            ARViewContainer(selectedPlanet: $selectedPlanetInformation, overlayToggle: $overlayShow)
                .edgesIgnoringSafeArea(.all)
            VStack{
                    Button{
                        reset = nil
                    }
                    label:{
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("Back")
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding()
                    }
                PickPlanetView(show: $overlayShow)
                PlanetSpeedSlider(show: $overlayShow, value: $speed)
                Spacer()
                PlanetOverlayView(planet: $selectedPlanetInformation, show: $overlayShow)
            }
        }
        .onChange(of: overlayShow){
            if !overlayShow{
                Planet.changeRotationModifier(1)
                speed = 1
            }
        }
        .onChange(of: speed){
            Planet.changeRotationModifier(speed)
        }
    }
}



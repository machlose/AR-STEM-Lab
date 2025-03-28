//
//  Planet Overlay.swift
//  SphereAR
//
//  Created by uczen on 27/03/2025.
//

import SwiftUI

struct PlanetOverlayView: View {
    @Binding var planet: PlanetInformation?
    @State private var offset: CGSize = CGSize(width: 0, height: 400)
    @Binding var show: Bool
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top){
                Text(planet?.name ?? "")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            .padding()
            Divider()
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text("Opis:")
                        .font(.title2)
                        .bold()
                    ScrollView{
                        Text(planet?.description ?? "")
                            .font(.title3)
                    }
                }
                .padding()
                
                Divider()
                
                VStack(alignment: .center){
                    Text("Promień")
                        .font(.title2)
                        .bold()
                    Group{
                        Text(planet?.radius ?? "")
                            .font(.title2)
                    }
                    Spacer()
                    Text("Masa")
                        .font(.title2)
                        .bold()
                    Text(planet?.mass ?? "")
                        .font(.title2)
                    Spacer()

                }
                .padding()
            }
        }
        .frame(height: 300)
        .background(.thinMaterial)
        .tint(.red)
        .cornerRadius(10)
        .offset(offset)
        .onChange(of: show){
            if show{
                withAnimation{
                    offset.height = 0
                }
            }
            else{
                withAnimation{
                    offset.height = 400
                }
            }
        }
    }
}

#Preview {
}

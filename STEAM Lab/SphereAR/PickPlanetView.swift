//
//  PickPlanetView.swift
//  SphereAR
//
//  Created by uczen on 28/03/2025.
//

import SwiftUI

struct PickPlanetView: View {
    @State private var offset: CGSize = CGSize(width: 0, height: 0)
    @Binding var show: Bool
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
            .offset(offset)
            .onChange(of: show){
                if !show{
                    withAnimation{
                        offset.height = 0
                    }
                }
                else{
                    withAnimation{
                        offset.height = -200
                    }
                }
            }
        }
    }
}

#Preview {
}

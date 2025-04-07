//
//  PickPlanetView.swift
//  SphereAR
//
//  Created by uczen on 28/03/2025.
//

import SwiftUI

struct PickPlanetView: View {
    @State private var offset: CGSize = CGSize(width: 0, height: -300)
    @Binding var show: Bool
    var body: some View {
        OffsetWrapper(show: $show, offset: offset, invertState: true){
            VStack{
                HStack{
                    Spacer()
                    Text("Kliknij w planetę aby ją wybrać")
                    Spacer()
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(20)
            }
        }
    }
}

#Preview {
}

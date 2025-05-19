//
//  ParticleView.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//
import SwiftUI

struct ParticleView: View {
    // Wybrana planeta – gdy nie jest nil, wyświetlamy overlay z informacjami
    @Binding var reset: Experiments?

    var body: some View {
        ZStack {
            ParticleARViewContainer()
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
                Spacer()
            }
        }
    }
}

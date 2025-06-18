//
//  ParticleView.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//
import SwiftUI

struct ParticleView: View {
    @EnvironmentObject var appState: AppState
    @Binding var reset: Experiments?

    var body: some View {
        ZStack {
            ParticleARViewContainer(currentAtom: $appState.particle_pickedAtom)
                .environmentObject(appState)
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
            ContentDrawer(title:"Atomy",ContentHeight: 800){
                AtomSelectView()
                    .background(.clear)
            }
        }
    }
}

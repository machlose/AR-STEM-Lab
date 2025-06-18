//
//  CellsView.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//


import SwiftUI

struct CellsView: View {
    // Wybrana planeta – gdy nie jest nil, wyświetlamy overlay z informacjami
    @Binding var reset: Experiments?

    var body: some View {
        ZStack {
            CellsARViewContainer()
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

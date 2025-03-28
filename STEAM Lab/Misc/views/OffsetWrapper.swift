//
//  OffsetWrapper.swift
//  STEAM Lab
//
//  Created by uczen on 28/03/2025.
//

import SwiftUI

struct OffsetWrapper<Label:View>: View {
    @Binding var show: Bool
    let offset: CGSize
    @State private var dynOffset: CGSize = CGSize(width: 0,height: 0)
    @ViewBuilder var labelView: () -> Label
    
    var body: some View {
        labelView()
        .onAppear{
            if !show{
                dynOffset = offset
            }
        }
        .offset(dynOffset)
        .onChange(of: show){
            if show{
                withAnimation{
                    dynOffset.height = 0
                }
            }
            else{
                withAnimation{
                    dynOffset.height = offset.height
                }
            }
        }
    }
}

#Preview {
}

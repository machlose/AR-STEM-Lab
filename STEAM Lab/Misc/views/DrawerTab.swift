//
//  DrawerTab.swift
//  STEAM Lab
//
//  Created by uczen on 12/05/2025.
//

import SwiftUI

struct DrawerTab: View {
    @Binding var title :String;
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.black.opacity(0.001))
//                .fill(.ultraThinMaterial)
//                .blendMode(.destinationOut)
            HStack{
                Spacer()
                VStack{
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .frame(width: 60,height: 10)
                        .cornerRadius(10)
                    Spacer()
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
    }
}

#Preview {
    ContentDrawer{
        Text("a")
    }
}

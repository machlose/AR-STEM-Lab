//
//  AtomicIcon.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 19/05/2025.
//

import SwiftUI

struct AtomicIcon: View {
    @State var atom: Atom
    @State var size: CGSize = CGSize(width: 200, height: 150)
    var body: some View {
        ZStack{
            Rectangle()
                .fill((atom.color != nil ? atom.color : .clear)!.secondary)
                .cornerRadius(20)
            ZStack{
                VStack{
                    HStack{
                        Text("\(atom.id)")
                            .font(.title2)
                        Spacer()
                        Text("\(String(format:"%.2f",atom.mass))")
                            .font(.title2)
                    }
                    Spacer()
                }
                HStack{
                    Text("\(atom.name)")
                        .font(.title)
                        .bold()
                    
                }
            }
            .padding()
            
        }
        .frame(width: size.width,height: size.height)
    }
}

#Preview {
    AtomSelectView()
}

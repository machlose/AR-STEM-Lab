//
//  AtomicIcon.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 19/05/2025.
//

import SwiftUI

struct AtomicIcon: View {
    @State var atom: Atom
    @State var size: CGSize = CGSize(width: 35, height:35)
    var body: some View {
        ZStack{
            Rectangle()
                .fill((atom.color != nil ? atom.color : .clear)!.secondary)
                .cornerRadius(2)
            ZStack{
                VStack{
                    HStack{
                        Text("\(atom.id)")
                            .font(.system(size: 6))
                        Spacer()
                        Text("\(Int(atom.mass))")
                            .font(.system(size: 6))
                    }
                    Spacer()
                    Text("\(atom.name)")
                        .font(.system(size: 5))
                }
                HStack{
                    Text("\(atom.short)")
                        .font(.system(size: 10))
                        .bold()
                    
                }
            }
            .padding(1)
            
        }
        .frame(width: size.width,height: size.height)
    }
}

#Preview {
    AtomSelectView()
}

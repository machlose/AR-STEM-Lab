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
    @State private var color: Color = Color.clear
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.experimentButton)
                .cornerRadius(2)
            Rectangle()
                .fill(color.secondary)
                .cornerRadius(2)
            ZStack{
                VStack{
                    HStack{
                        Text("\(atom.id)")
                            .font(.system(size: 6))
                        Spacer()
                        Text("\(Int(atom.atomicMass))")
                            .font(.system(size: 6))
                    }
                    Spacer()
                    Text("\(atom.name)")
                        .font(.system(size: 5))
                }
                HStack{
                    Text("\(atom.symbol)")
                        .font(.system(size: 10))
                        .bold()
                    
                }
            }
            .padding(1)
            
        }
        .frame(width: size.width,height: size.height)
        .onAppear{
            switch atom.category{
                case .NonMetal:
                color = Color.biologyGreen
                case .none:
                    color =  Color.blue
                case .some(.AlkalineMetal):
                    color = Color.cyan
                case .some(.AlkalineEarthMetal):
                    color = Color.yellow
                case .some(.TransitionMetal):
                    color = Color.indigo
                case .some(.PostTransitionMetal):
                    color =  Color.mint
                case .some(.Metalloid):
                    color = Color.orange
                case .some(.Halogen):
                    color = Color.teal
                case .some(.NobleGas):
                    color = Color.green
                case .some(.Lanthanide):
                    color = Color.purple
                case .some(.Actinide):
                color = Color.chemistryYellow
            }
        }
    }
}

#Preview {
    AtomSelectView()
}

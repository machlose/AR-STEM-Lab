//
//  AtomSelect.swift
//  STEAM Lab
//
//  Created by uczen on 11/05/2025.
//

import SwiftUI
 
struct AtomSelectView: View {
    @EnvironmentObject var appState: AppState
    @State var string: String = ""
    @State var notShownAtoms: [Int] = []
    var body: some View {
        ZStack{
            PeriodicTable(notShownAtoms: $notShownAtoms)
            VStack(){
                VStack(){
                    HStack(){
                        Text("ATOMY")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Spacer()
                    }
                    TextField("Wyszukaj atom", text:$string)
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 0
                    )
                )
                Spacer()
            }
        }
        .onChange(of: string){
            getAtomsByString()
        }
    }
    func getAtomsByString(){
        notShownAtoms = []
        if string == "" {return}
        for atom in Atoms{
            if(atom.name.lowercased().starts(with:string.lowercased()) == false &&
               atom.short.lowercased().starts(with:string.lowercased()) == false){
                notShownAtoms.append(atom.id)
            }
        }
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

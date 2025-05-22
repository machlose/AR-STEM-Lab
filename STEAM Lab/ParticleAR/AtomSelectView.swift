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
        NavigationStack{
            VStack(){
                HStack(){
                    Text("ATOMY")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
                }
                ZStack{
                    TextField("Wyszukaj atom", text:$string)
                }
                PeriodicTable(notShownAtoms: $notShownAtoms)
                Spacer()
            }
        }
        .onChange(of: string){
            getAtomsByString()
        }
        .padding(.horizontal)
        .navigationTitle("Wybierz atom")
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
        print(notShownAtoms)
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

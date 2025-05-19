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
    @State var atomy = Atoms
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
            ScrollView{
                    ForEach(atomy) { atom in
                        ZStack{
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .cornerRadius(20)
                            HStack{
                                AtomicIcon(atom: atom)
                                Spacer()
                                HStack{
                                    VStack{
                                        Text(atom.description)
                                            .multilineTextAlignment(.leading)
                                            .font(.title2)
                                        Spacer()
                                        
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                        .frame(height: 150)
                        .padding(.bottom)
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear{
            atomy.remove(at: 0)
        }
        .navigationTitle("Wybierz atom")
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

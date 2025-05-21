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
                PeriodicTable()
            }
        }
        .padding(.horizontal)
        .navigationTitle("Wybierz atom")
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

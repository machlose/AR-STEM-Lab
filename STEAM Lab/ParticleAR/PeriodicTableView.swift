//
//  PeriodicTableView.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//

import SwiftUI

struct PeriodicTable: View {
    @State var AtomViews:[[AnyView]] = []
    @State private var update: Bool = false;
    @State var atomy = Atoms
    var body: some View {
        VStack{
            if(update){
                ScrollView([.horizontal,.vertical]){
                    Grid{
                        ForEach(0..<AtomViews.count){ index in
                            GridRow{
                                ForEach(0..<AtomViews[index].count){ atom in
                                    AtomViews[index][atom]
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            atomy.remove(at: 0)
            var atomSubranges: [[Atom]] = [[],[]]
        
            for i in 57...70{
                atomSubranges[0].append(atomy[i])
            }
            for i in 89...102{
                atomSubranges[1].append(atomy[i])
            }
            atomy.removeSubrange(89...102)
            atomy.removeSubrange(57...70)
            
            atomy.append(contentsOf: atomSubranges[0])
            atomy.append(contentsOf: atomSubranges[1])
        
            generateAtoms()
            update = !update
        }
    }
    func generateAtoms(){
        for i in 0..<rowCounts.count{
            self.AtomViews.append([]);
            for j in 0..<rowCounts[i]{
                let index = (rowStarts[i]+j)
                if spacings[index] != nil{
                    let num:Int = spacings[index] ?? -1
                    for _ in 0..<num{
                        self.AtomViews[i].append(AnyView(AtomicGridSpacer()))
                    }
                }
                self.AtomViews[i].append(AnyView(AtomicIcon(atom: atomy[index])))
            }
            
        }
    }
}

#Preview {
    PeriodicTable()
        .environmentObject(AppState())
}

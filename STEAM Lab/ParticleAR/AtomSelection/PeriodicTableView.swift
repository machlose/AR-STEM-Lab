//
//  PeriodicTableView.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//

import SwiftUI

struct PeriodicTable: View {
    @EnvironmentObject var appState: AppState
    @Binding var notShownAtoms: [Int]
    let maxZoom = 2.0
    @State var AtomViews:[[(view:AnyView,atom:Atom?)]] = []
    @State private var update: Bool = false;
    @State private var scale: Double = 1.0
    @State private var currentZoom: Double = 0
    @State private var size: CGSize = CGSize()
    @State var atomy = Atoms
    var body: some View {
        VStack(){
            if(update){
                ScrollView([.horizontal,.vertical]){
                        Grid(horizontalSpacing: 2, verticalSpacing: 2){
                            ForEach(0..<AtomViews.count){ index in
                                GridRow{
                                    ForEach(0..<AtomViews[index].count){ atom in
                                        ZStack{
                                            AtomViews[index][atom].view
                                            if(AtomViews[index][atom].atom != nil){
                                                if(notShownAtoms.contains(AtomViews[index][atom].atom!.id)){
                                                    Color.black
                                                        .frame(width: 35, height: 35).opacity(0.6)
                                                }
                                            }
                                        }
                                        .onTapGesture{
                                            appState.particle_pickedAtom = AtomViews[index][atom].atom!.id
                                        }
                                    }
                                }
                            }
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .onAppear {
                                        size = proxy.size
                                    }
                            }
                        )
                        .frame(width: size.width*(scale+currentZoom)+500*(scale+currentZoom - 1), height: size.height*(scale+currentZoom)+500)
                        .scaleEffect(scale+currentZoom)
                        .background(.black.opacity(0.001))
                        .simultaneousGesture(MagnifyGesture())
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    currentZoom = value.magnification - 1
                                    if(currentZoom+scale > maxZoom){
                                        currentZoom = maxZoom-scale
                                    }
                                    if(currentZoom+scale < 1.0){
                                        currentZoom = 1.0-scale
                                    }
                                }
                                .onEnded { value in
                                    scale += currentZoom
                                    currentZoom = 0
                                }
                        )
                        .accessibilityZoomAction { action in
                            if action.direction == .zoomIn {
                                scale += 1
                            } else {
                                scale -= 1
                            }
                        }
                    }
//                    .frame(width: size.width*(scale+currentZoom), height: size.height*(scale+currentZoom))
                }
        }
        .scrollIndicators(.hidden)
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
                        self.AtomViews[i].append((view:AnyView(AtomicGridSpacer()),atom:Optional<Atom>.none))
                    }
                }
                self.AtomViews[i].append((view:AnyView(AtomicIcon(atom: atomy[index])),atom:atomy[index]))
            }
        }
    }
}

#Preview {
    AtomSelectView()
        .environmentObject(AppState())
}

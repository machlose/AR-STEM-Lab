//
//  ContentDrawer.swift
//  STEAM Lab
//
//  Created by uczen on 03/05/2025.
//

import SwiftUI

struct ContentDrawer: View {
    @State var translation: CGSize = CGSize()
    @State var DrawerState: Bool = false
    @State var BaseTranslation: CGSize = CGSize()
    let TabHeight: CGFloat = 100
    var body: some View {
        GeometryReader{ gd in
            ZStack{
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .frame(width: gd.size.width, height: TabHeight+gd.size.height)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 20,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 20
                        )
                    )
                    .offset(x:0, y:translation.height-25)
                VStack{
                    DrawerTab()
                    .frame(width: gd.size.width,height: TabHeight)
                    .offset(translation)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                setTranslation(value: value,gd: gd)
                            }
                            .onEnded { value in
                                setDrawerState()
                                setBaseTranslation(gd: gd)
                                withAnimation {
                                    translation = BaseTranslation
                                }
                            }
                    )
                    VStack{
                        Divider()
                        Spacer()
                        Button(
                            action:{
                                
                            },
                            label:{
                                Text("anafaza")
                            }
                        )
                        Spacer()
                    }
                    .padding([.bottom])
                    .frame(width: gd.size.width, height:500)
                    .offset(translation)
                }
                .geometryGroup()
                .onAppear{
                    setBaseTranslation(gd: gd)
                    translation.height = BaseTranslation.height
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .top)
                .ignoresSafeArea()
            }
            
        }
    }
    func setTranslation(value: DragGesture.Value,gd: GeometryProxy){
        let translationHeight = value.location.y-value.startLocation.y
        if BaseTranslation.height-100 > translation.height &&
           translation.height < gd.size.height-TabHeight-500+25
        {
            translation.height = gd.size.height-TabHeight-500+25-101
        }
        else{
            translation = CGSize(
                width: 0,
                height: BaseTranslation.height + translationHeight
            )
        }
    }
    func setDrawerState(){
        if abs(translation.height-BaseTranslation.height) > 200{
            DrawerState = !DrawerState
        }
    }
    func setBaseTranslation(gd :GeometryProxy){
        if DrawerState{
            BaseTranslation = CGSize(width: .zero, height: gd.size.height-TabHeight-500+25)
        }
        else{
            BaseTranslation = CGSize(width: .zero, height: gd.size.height+50-TabHeight)
        }
    }
}

#Preview {
    ContentDrawer()
}

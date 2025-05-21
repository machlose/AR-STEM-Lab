//
//  ContentDrawer.swift
//  STEAM Lab
//
//  Created by uczen on 03/05/2025.
//

import SwiftUI

struct ContentDrawer<Label:View>: View {
    @ViewBuilder var content: () -> Label
    @State var translation: CGSize = CGSize()
    @State var DrawerState: Bool = false
    @State var BaseTranslation: CGSize = CGSize()
    @State var DrawerTitle: String
    @State var ContentHeight: CGFloat
    let TabHeight: CGFloat
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
                    DrawerTab(title: $DrawerTitle)
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
                        content()
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            print(ContentHeight)
                                            if ContentHeight == 0{
                                                ContentHeight = proxy.size.height+50
                                            }
                                        }
                                }
                            )
                        Spacer()
                    }
                    .frame(width: gd.size.width, height:ContentHeight)
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
        let TopPosition = gd.size.height-TabHeight-ContentHeight
        if TopPosition-ContentHeight/3 > translation.height &&
            translation.height < TopPosition
        {
            translation.height = TopPosition-ContentHeight/3-1
        }
        else{
            translation = CGSize(
                width: 0,
                height: BaseTranslation.height + translationHeight
            )
        }
    }
    func setDrawerState(){
        if abs(translation.height-BaseTranslation.height) > ContentHeight/2{
            DrawerState = !DrawerState
        }
    }
    func setBaseTranslation(gd :GeometryProxy){
        if DrawerState{
            BaseTranslation = CGSize(width: .zero, height: gd.size.height-TabHeight-ContentHeight)
        }
        else{
            BaseTranslation = CGSize(width: .zero, height: gd.size.height+50-TabHeight)
        }
    }
    init(title: String,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = 0
        self.TabHeight = 100
        self.DrawerTitle = title;
    }
    init(title: String,TabHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = 0
        self.TabHeight = TabHeight
        self.DrawerTitle = title;
    }
    init(title: String,ContentHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = ContentHeight
        self.TabHeight = 100
        self.DrawerTitle = title;
    }
    init(title: String,ContentHeight: CGFloat,TabHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = ContentHeight
        self.TabHeight = TabHeight
        self.DrawerTitle = title;
    }
    init(content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = 0
        self.TabHeight = 100
        self.DrawerTitle = "";
    }
    init(TabHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = 0
        self.TabHeight = TabHeight
        self.DrawerTitle = "";
    }
    init(ContentHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = ContentHeight
        self.TabHeight = 100
        self.DrawerTitle = "";
    }
    init(ContentHeight: CGFloat,TabHeight: CGFloat,content: @escaping () -> Label){
        self.content = content
        self.ContentHeight = ContentHeight
        self.TabHeight = TabHeight
        self.DrawerTitle = "";
    }
}

#Preview {
    ContentDrawer(title:"Bryły",ContentHeight: 1000){
        AtomSelectView()
    }
}

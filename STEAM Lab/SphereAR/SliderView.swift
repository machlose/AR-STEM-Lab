//
//  PlanetSpeedSliderView.swift
//  STEAM Lab
//
//  Created by uczen on 30/03/2025.
//

import SwiftUI

struct SliderView: View {
    let height: CGFloat = 40
    @Binding var outValue: Double
    @State private var Value: Double = 0
    @State private var LastValue: Double = 0
    
    var body: some View {
        GeometryReader{ gr in
            let padd = height/20
            let width = gr.size.width
            let radius = gr.size.height * 0.2
            ZStack{
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(.ultraThinMaterial)
                HStack(){
                    RoundedRectangle(cornerRadius: radius)
                        .frame(width: height, height: height)
                        .offset(x:((-width/2)+(height)/2)+Value+padd,y:0)
                        .padding(padd)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged{ value in
                                    Value = LastValue + value.translation.width
                                    Value.clamp(min: 0, max: width-height-padd)
                                    outValue = Double(Value)/Double(width-height-padd)
                                }
                                .onEnded{_ in 
                                    LastValue = Value
                                }
                        )
                        .foregroundStyle(.baseFont)
                }
            }
            .onAppear{
                Value = outValue*(gr.size.width-height-padd)
                LastValue = outValue*(gr.size.width-height-padd)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    SolarView()
}

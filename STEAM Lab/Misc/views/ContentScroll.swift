//
//  ContentScroll.swift
//  STEAM Lab
//
//  Created by uczen on 14/05/2025.
//

import SwiftUI

struct ContentScroll: View {
    var body: some View {
        GeometryReader{ gr in
            VStack{
                ScrollView(.horizontal){
                    HStack{
                        ForEach(0..<10){ _ in
                            ZStack{
                                Rectangle()
                                    .fill(.white)
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 10,
                                            bottomLeadingRadius: 10,
                                            bottomTrailingRadius: 10,
                                            topTrailingRadius: 10
                                        )
                                    )
                            }
                            .frame(width:200,height: 200)
                            .padding()
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 200)
    }
}

#Preview {
    ContentScroll()
        .background(.black)
}

//
//  scrollViewTest.swift
//  STEAM Lab
//
//  Created by uczen on 22/05/2025.
//

import SwiftUI

struct scrollViewTest: View {
    var body: some View {
        ScrollView{
            Button (action:{
                print("tapped")
                },label:{
                    Rectangle()
                        .frame(width: 100,height: 100)
                }
            )
        }
        .onTapGesture {
        }
    }
}

#Preview {
    scrollViewTest()
}

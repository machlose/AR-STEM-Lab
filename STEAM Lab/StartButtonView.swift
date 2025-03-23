//
//  StartButtonView.swift
//  STEAM Lab
//
//  Created by uczen on 23/03/2025.
//

import SwiftUI

struct StartButtonView: View {
    let content: String
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(content)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundStyle(.baseFont)
            }
        }
        .padding()
        .background(.startButton)
        .cornerRadius(10)
        .shadow(color: .primary.opacity(0.25), radius: 1, x:0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    StartButtonView(content: "Start")
}

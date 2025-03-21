//
//  TitleSection.swift
//  STEM Lab
//
//  Created by uczen on 21/03/2025.
//

import SwiftUI

struct TitleSectionView: View {
    var body: some View {
        HStack(alignment: .center){
            Image("logo")
                .resizable()
                .frame(width: 70,height: 70)
            Text("STEM Lab")
                .font(.title)
                .bold()
        }
    }
}

#Preview {
    TitleSectionView()
}

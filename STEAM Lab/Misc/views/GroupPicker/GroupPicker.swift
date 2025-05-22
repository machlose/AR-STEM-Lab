//
//  GroupPicker.swift
//  STEAM Lab
//
//  Created by uczen on 22/05/2025.
//

import SwiftUI

struct GroupPicker: View {
    var body: some View {
        GroupButton()
        ScrollView([.horizontal]){
            HStack{
                ForEach(0..<5){ _ in
                    GroupButton()
                }
            }
        }
    }
}

#Preview {
    GroupPicker()
}

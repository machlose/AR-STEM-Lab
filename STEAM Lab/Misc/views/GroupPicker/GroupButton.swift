//
//  GroupButton.swift
//  STEAM Lab
//
//  Created by uczen on 22/05/2025.
//

import SwiftUI

struct GroupButton: View {
    @State var checked: Bool = false
    var body: some View {
        Button(
            action: {
                checked = !checked
            },
            label: {
                HStack{
                    Text("bomba")
                    if(checked){
                        withAnimation{
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding(10)
                .padding(.horizontal,5)
                .foregroundStyle(.font)
                .background(checked ?  .red.opacity(0.1) : .experimentButton)
                .cornerRadius(20)
            }
        )
    }
}

#Preview {
    GroupButton()
}

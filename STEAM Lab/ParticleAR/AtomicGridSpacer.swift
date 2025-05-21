//
//  AtomicGridSpacer.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//

import SwiftUI

struct AtomicGridSpacer: View {
    var body: some View {
        Color.clear
            .frame(width: 35, height: 35)
            .gridCellUnsizedAxes([.horizontal,.vertical])
    }
}

#Preview {
    AtomicGridSpacer()
}

//
//  SelectViewHelper.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//

import SwiftUI
import Foundation

let spacings: [Int:Int] = [1:16,4:10,12:10,90:3,104:3]
//let spacings = [(index:1,count:16),(index:4,count:10),(index:12,count:10)]
let rowCounts = [2,8,8,18,18,18,18,14,14]
let rowStarts = [0,2,10,18,36,54,72,90,104]

#Preview{
    AtomSelectView()
}

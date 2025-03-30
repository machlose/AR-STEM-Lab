//
//  DoubleExtension.swift
//  STEAM Lab
//
//  Created by uczen on 30/03/2025.
//

extension Double{
    mutating func clamp(min: Double,max:Double){
        if self < min{
           self = min
        }
        if self > max{
            self = max
        }
    }
}

//
//  SIMD3.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 28/04/2025.
//
import Foundation

extension SIMD3 where Scalar == Float{
    func Normalized() -> SIMD3{
        var vector = SIMD3<Float>()
        var length = sqrt((self.x*self.x)+(self.y*self.y)+(self.z*self.z))
        vector.x = self.x/length
        vector.y = self.y/length
        vector.z = self.z/length
        return vector;
    }
}


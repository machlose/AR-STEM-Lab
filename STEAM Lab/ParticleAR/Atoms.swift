//
//  Atoms.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//

import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji

let Proton: Particle = Particle(name: "Proton", textureName: "proton", radius: 1, orbitRadius: 0, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Neuton: Particle = Particle(name: "Neuton", textureName: "neuton", radius: 1, orbitRadius: 0, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Electron: Particle = Particle(name: "Electron", textureName: "electron", radius: 1, orbitRadius: 1, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1)


class Atom {
    var name: String = "Wodór"
    var number: Int = 1
    var mass: Float = 1.0
    var particles: [Particle] = []
    
    init(name: String = "test", number: Int = 0, mass: Float = 0, particles: [Particle] = []) {
        self.name = name
        self.number = number
        self.mass = mass
        self.particles = particles
    }
}

let Atoms: [Atom] = [
    Atom(),
    Atom(
        name: "Wodór",
        number: 1,
        mass: 1.0,
        particles: [
            Particle(name: "Proton", textureName: "proton", radius: 1, orbitRadius: 0, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0),
            Particle(name: "Electron", textureName: "electron", radius: 1, orbitRadius: 0, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
        ]
    )
]

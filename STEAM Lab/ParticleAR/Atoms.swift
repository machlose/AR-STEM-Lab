//
//  Atoms.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//

import SwiftUI
import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji


func generateAtomicCenter_(Protons: Int, Neutrons: Int) -> [Particle] {
    var particles: [Particle] = []
    var positions: [SIMD3<Float>] = []
    let total = Protons + Neutrons
    let spacing: Float = 0.06 * scale
    let radius: Float = 0.1 * scale

    // Rozmieszczanie punktów na sferze
    for _ in 0..<total {
        let theta = Float.random(in: 0..<2 * .pi)
        let phi = Float.random(in: 0..<(.pi))
        let r = spacing * Float.random(in: 0.5...1.0)

        let x = r * sin(phi) * cos(theta)
        let y = r * sin(phi) * sin(theta)
        let z = r * cos(phi)

        positions.append(SIMD3<Float>(x, y, z))
    }

    positions.shuffle()

    for i in 0..<Protons {
        particles.append(Particle(
            name: "Proton",
            textureName: "proton",
            radius: radius,
            orbitRadius: 0,
            orbitCenter: positions[i],
            orbitSpeed: 0)
        )
    }

    for i in 0..<Neutrons {
        particles.append(Particle(
            name: "Neutron",
            textureName: "neutron",
            radius: radius,
            orbitRadius: 0,
            orbitCenter: positions[Protons + i],
            orbitSpeed: 0)
        )
    }

    return particles
}

func generateElectrons(K: Int = 1, L: Int = 0, M: Int = 0, N: Int = 0, O: Int = 0, P: Int = 0) -> [Particle] {
    //let shellCapacities = [2, 8, 18, 32, 50 ,72]
    var electrons: [Particle] = []

    for i in 0..<K {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.25 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(K))
        )
    }
    
    for i in 0..<L {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.35 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(L))
        )
    }
    
    for i in 0..<M {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.45 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(Double(M)))
        )
    }
    
    for i in 0..<N {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.55 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(Double(N)-1.5))
        )
    }
    
    for i in 0..<O {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.65 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(O-2))
        )
    }
    
    for i in 0..<P {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.75 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(P))
        )
    }

    return electrons
}


class Atom_: Identifiable {
    var id: Int { number }
    var name: String = "Wodór"
    var short: String = ""
    var category: PeriodCategories? = nil
    var number: Int = 1
    var mass: Float = 1.0
    var description: String = ""
    var protons: Int = 1
    var neutrons: Int = 0
    var K: Int = 1
    var L: Int = 0
    var M: Int = 0
    var N: Int = 0
    var O: Int = 0
    var P: Int = 0
    var R: Int = 0
    var particles: [Particle] = []
    
    init(name: String = "test", short: String = "", category: PeriodCategories? = nil, number: Int = 0, mass: Float = 0, description: String = "", Protons: Int = 1, Neutrons: Int = 0, K: Int = 0, L: Int = 0, M: Int = 0, N: Int = 0, O: Int = 0, P: Int = 0, R: Int = 0, particles: [Particle] = []) {
        self.name = name
        self.short = short
        self.category = category
        self.number = number
        self.mass = mass
        self.description = description
        self.protons = Protons
        self.neutrons = Neutrons
        self.K = K
        self.L = L
        self.M = M
        self.N = N
        self.O = O
        self.P = P
        self.R = R
        self.particles = particles
    }
}



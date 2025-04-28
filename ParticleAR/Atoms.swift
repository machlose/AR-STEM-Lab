//
//  Atoms.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//

import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji

let Proton: Particle = Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Neuton: Particle = Particle(name: "Neuton", textureName: "neuton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Electron: Particle = Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.15 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1)

let scale:Float = 1
let speed:Float = 3

func generateElectronShells(electronCount: Int) -> [Particle] {
    let shellCapacities = [2, 8, 18, 32]
    let baseRadius: Float = 0.25 * scale
    var electrons: [Particle] = []
    var remaining = electronCount
    var shellIndex = 0

    while remaining > 0 && shellIndex < shellCapacities.count {
        let electronsInShell = min(remaining, shellCapacities[shellIndex])
        let orbitRadius = baseRadius + Float(shellIndex) * 0.1 * scale

        for i in 0..<electronsInShell {
            electrons.append(
                Particle(
                    name: "Electron",
                    textureName: "electron",
                    radius: 0.02 * scale,
                    orbitRadius: orbitRadius,
                    orbitCenter: SIMD3<Float>(0, 0, 0),
                    orbitSpeed: 1 * speed,
                    orbitTimeOffset: 6 / speed * Float(i) / Float(electronsInShell)
                )
            )
        }

        remaining -= electronsInShell
        shellIndex += 1
    }

    return electrons
}


class Atom {
    var name: String = "Wodór"
    var number: Int = 1
    var mass: Float = 1.0
    var description: String = ""
    var particles: [Particle] = []
    
    init(name: String = "test", number: Int = 0, mass: Float = 0, description: String = "", particles: [Particle] = []) {
        self.name = name
        self.number = number
        self.mass = mass
        self.description = description
        self.particles = particles
    }
}

let Atoms: [Atom] = [
    Atom(),
    // Wodór
    Atom(
        name: "Wodór",
        number: 1,
        mass: 1.0,
        description: "Najprostszy atom, składa się z jednego protonu i jednego elektronu.",
        particles: [
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0*speed),
            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.15 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1*speed)
        ]
    ),
    // Hel
    Atom(
        name: "Hel",
        number: 2,
        mass: 4.0,
        description: "Atom helu, składający się z dwóch protonów, dwóch neutronów i dwóch elektronów.",
        particles: [
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, 0.0), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, 0.0), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, 0.05, 0.05), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, -0.05, -0.05), orbitSpeed: 0),
            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.25 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1 * speed, orbitTimeOffset: 0),
            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.25 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1 * speed, orbitTimeOffset: 1)
        ]

    ),
    // Węgiel
    Atom(
        name: "Węgiel",
        number: 6,
        mass: 12.0,
        description: "Atom węgla, składający się z sześciu protonów, sześciu neutronów i sześciu elektronów.",
        particles: [
            // Protony
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, 0.05), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, 0.05), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, 0.05, -0.05), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, -0.05, -0.05), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.07, 0.00), orbitSpeed: 0),
            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, -0.07, 0.00), orbitSpeed: 0),

            // Neutrony
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.07, 0.00, 0.00), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.07, 0.00, 0.00), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.00, 0.07), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.00, -0.07), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, -0.05), orbitSpeed: 0),
            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, -0.05), orbitSpeed: 0),

            // Elektrony
            
        ] + generateElectronShells(electronCount: 6)

    )
]



//let Atoms: [Atom] = [
//    Atom(),
//    Atom(
//        name: "Wodór",
//        number: 1,
//        mass: 1.0,
//        description: "",
//        particles: [
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0*speed),
//            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.15 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1*speed)
//        ]
//    )
//]

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

func generateAtomicCenter(Protons: Int, Neutrons: Int) -> [Particle]{
    var particles: [Particle] = []
    var positions: [SIMD3<Float>] = []
    
    for i in 0..<(Protons+Neutrons){
        
    }
    
    positions.shuffle()
    
    for i in 0..<Protons{
        particles.append(Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: positions[i], orbitSpeed: 0))
    }
    
    for i in 0..<Neutrons{
        particles.append(Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: positions[Protons+i], orbitSpeed: 0))
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
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.45 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(M))
        )
    }
    
    for i in 0..<N {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.55 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(N))
        )
    }
    
    for i in 0..<O {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.65 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(O))
        )
    }
    
    for i in 0..<P {
        electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.75 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(P))
        )
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
            
        ] + generateElectrons(K: 0, L: 4)
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

//
//  AtomV2.swift
//  STEAM Lab
//
//  Created by uczen on 24/05/2025.
//

import SwiftUI
import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji
let Proton: Particle = Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Neuton: Particle = Particle(name: "Neuton", textureName: "neuton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0)
let Electron: Particle = Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.15 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1)

let scale:Float = 1
let speed:Float = 3

func generateAtomicCenter(Protons: Int, Neutrons: Int) -> [Particle] {
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

func generateElectrons(shells: [Int]) -> [Particle] {
    //let shellCapacities = [2, 8, 18, 32, 50 ,72]
    var electrons: [Particle] = []

        var counter = 0
        for i in shells {
            for j in 0..<i {
                let radius = (0.25+Float(counter)*0.1)
                electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: radius * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(j) / Float(i))
            )
            }
            counter+=1
        }

    return electrons
}


func generateElectrons_(K: Int = 1, L: Int = 0, M: Int = 0, N: Int = 0, O: Int = 0, P: Int = 0) -> [Particle] {
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
struct Atom: Codable {
    var id: Int {number}
    let name: String
    let appearance: String?
    let atomicMass: Double
    var protons: Int
    var neutrons: Int
    let boil: Double?
    var category: PeriodCategories? = nil
    let density: Double?
    let discoveredBy: String?
    let melt, molarHeat: Double?
    let namedBy: String?
    let number, period, group: Int
    let phase: Phase
    let source: String
    let summary, symbol: String
    let shells: [Int]
    let electronConfiguration, electronConfigurationSemantic: String
    let electronAffinity, electronegativityPauling: Double?
    let ionizationEnergies: [Double]
    let cpkHex: String?
    let block: Block

    
    enum CodingKeys: String, CodingKey {
        case name, appearance
        case atomicMass = "atomic_mass"
        case protons
        case neutrons
        case boil, category, density
        case discoveredBy = "discovered_by"
        case melt
        case molarHeat = "molar_heat"
        case namedBy = "named_by"
        case number, period, group, phase, source, summary, symbol, shells
        case electronConfiguration = "electron_configuration"
        case electronConfigurationSemantic = "electron_configuration_semantic"
        case electronAffinity = "electron_affinity"
        case electronegativityPauling = "electronegativity_pauling"
        case ionizationEnergies = "ionization_energies"
        case cpkHex = "cpk-hex"
        case block
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(appearance, forKey: .appearance)
        try container.encode(atomicMass, forKey: .atomicMass)
        try container.encode(protons, forKey: .protons)
        try container.encode(neutrons, forKey: .neutrons)
        try container.encode(boil, forKey: .boil)
        try container.encode(category, forKey: .category)
        try container.encode(density, forKey: .density)
        try container.encode(discoveredBy, forKey: .discoveredBy)
        try container.encode(melt, forKey: .melt)
        try container.encode(molarHeat, forKey: .molarHeat)
        try container.encode(namedBy, forKey: .namedBy)
        try container.encode(number, forKey: .number)
        try container.encode(period, forKey: .period)
        try container.encode(group, forKey: .group)
        try container.encode(phase, forKey: .phase)
        try container.encode(source, forKey: .source)
        try container.encode(summary, forKey: .summary)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(shells, forKey: .shells)
        try container.encode(electronConfiguration, forKey: .electronConfiguration)
        try container.encode(electronConfigurationSemantic, forKey: .electronConfigurationSemantic)
        try container.encode(electronAffinity, forKey: .electronAffinity)
        try container.encode(electronegativityPauling, forKey: .electronegativityPauling)
        try container.encode(ionizationEnergies, forKey: .ionizationEnergies)
        try container.encode(cpkHex, forKey: .cpkHex)
        try container.encode(block, forKey: .block)
    }
}

enum Block: String, Codable {
    case d = "d"
    case f = "f"
    case p = "p"
    case s = "s"
}

enum Phase: String, Codable {
    case gas = "Gas"
    case liquid = "Liquid"
    case solid = "Solid"
}

enum PeriodCategories: String,Codable{
    case NonMetal = "nonMetal",
         AlkalineMetal = "alkaliMetal",
         AlkalineEarthMetal = "alkaliEarthMetal",
         TransitionMetal = "transitionMetal",
         PostTransitionMetal = "postTransitionMetal",
         Metalloid = "metalloid",
         Halogen = "halogen",
         NobleGas = "nobleGas",
         Lanthanide = "lanthanide",
         Actinide = "actinide"
}

var Atoms = readDataFromFile(from: "PeriodicTableJSON") as [Atom]

//
//  AtomV2.swift
//  STEAM Lab
//
//  Created by uczen on 24/05/2025.
//

import SwiftUI
import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji

func generateAtomicCenterV2(Protons: Int, Neutrons: Int) -> [Particle] {
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

        for i in shells {
            for _ in 0..<shells[i] {
                electrons.append(Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.75 * scale, orbitCenter: SIMD3<Float>(0, 0, 0), orbitSpeed: 1 * speed, orbitTimeOffset: 6 / speed * Float(i) / Float(shells[i]))
            )
        }
    }

    return electrons
}
struct AtomV2: Codable {
    let name: String
    let appearance: String?
    let atomicMass: Double
    let boil: Double?
    let category: String
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

let Atoms2 = readDataFromFile(from: "PeriodicTableJSON") as [AtomV2]

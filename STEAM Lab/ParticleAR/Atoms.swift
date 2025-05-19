//
//  Atoms.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
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


class Atom: Identifiable {
    var id: Int { number }
    var name: String = "Wodór"
    var number: Int = 1
    var mass: Float = 1.0
    var description: String = ""
    var protons: Int = 1
    var neutrons: Int = 0
    var color: Color?
    var K: Int = 1
    var L: Int = 0
    var M: Int = 0
    var N: Int = 0
    var O: Int = 0
    var P: Int = 0
    var particles: [Particle] = []
    
    init(name: String = "test", number: Int = 0, mass: Float = 0, description: String = "", color: Color? = nil, Protons: Int = 1, Neutrons: Int = 0, K: Int = 0, L: Int = 0, M: Int = 0, N: Int = 0, O: Int = 0, P: Int = 0, particles: [Particle] = []) {
        self.name = name
        self.number = number
        self.mass = mass
        self.description = description
        self.color = color
        self.protons = Protons
        self.neutrons = Neutrons
        self.K = K
        self.L = L
        self.M = M
        self.N = N
        self.O = O
        self.P = P
        self.particles = particles
    }
}


let Atoms: [Atom] = [
    Atom(), // index 0: placeholder
    
    // 1: Wodór
    Atom(
        name: "Wodór",
        number: 1,
        mass: 1.0,
        description: "Najprostszy atom, składa się z jednego protonu i jednego elektronu.",
        color:.red,
        Protons: 1, Neutrons: 0, K: 1
    ),
    
    // 2: Hel
    Atom(
        name: "Hel",
        number: 2,
        mass: 4.0,
        description: "Atom helu, składający się z dwóch protonów, dwóch neutronów i dwóch elektronów.",
        Protons: 2, Neutrons: 2, K: 2
    ),

    // 3: Lit
    Atom(
        name: "Lit",
        number: 3,
        mass: 6.94,
        description: "Pierwiastek chemiczny z grupy metali alkalicznych, ma 3 protony i 3 elektrony.",
        Protons: 3, Neutrons: 4, K: 2, L: 1
    ),

    // 4: Beryl
    Atom(
        name: "Beryl",
        number: 4,
        mass: 9.01,
        description: "Mały, twardy metal alkaliczno-ziemny, posiadający 4 elektrony.",
        Protons: 4, Neutrons: 5, K: 2, L: 2
    ),

    // 5: Bor
    Atom(
        name: "Bor",
        number: 5,
        mass: 10.81,
        description: "Półmetaliczny pierwiastek z grupy borowców.",
        Protons: 5, Neutrons: 6, K: 2, L: 3
    ),

    // 6: Węgiel
    Atom(
        name: "Węgiel",
        number: 6,
        mass: 12.0,
        description: "Podstawowy pierwiastek życia, posiada 6 elektronów.",
        Protons: 6, Neutrons: 6, K: 2, L: 4
    ),

    // 7: Azot
    Atom(
        name: "Azot",
        number: 7,
        mass: 14.01,
        description: "Bardzo ważny pierwiastek w atmosferze, ma 7 protonów i 7 neutronów.",
        Protons: 7, Neutrons: 7, K: 2, L: 5
    ),
    
    // 8: Tlen
    Atom(
        name: "Tlen",
        number: 8,
        mass: 16.0,
        description: "Pierwiastek, który jest niezbędny do życia, szczególnie w oddychaniu, z 8 elektronami.",
        Protons: 8, Neutrons: 8, K: 2, L: 6
    ),
    
    // 9: Fluor
    Atom(
        name: "Fluor",
        number: 9,
        mass: 18.998,
        description: "Fluor to pierwiastek bardzo reaktywny, z 9 protonami i 9 elektronami.",
        Protons: 9, Neutrons: 10, K: 2, L: 7
    ),
    
    // 10: Neón
    Atom(
        name: "Neón",
        number: 10,
        mass: 20.18,
        description: "Neon jest jednym z gazów szlachetnych, posiada 10 protonów i 10 elektronów.",
        Protons: 10, Neutrons: 10, K: 2, L: 8
    ),
    
    // 11: Sód
    Atom(
        name: "Sód",
        number: 11,
        mass: 22.99,
        description: "Sód to metal alkaliczny, który ma 11 protonów, 11 elektronów i 12 neutronów.",
        Protons: 11, Neutrons: 12, K: 2, L: 8, M: 1
    ),
    
    // 12: Magnez
    Atom(
        name: "Magnez",
        number: 12,
        mass: 24.31,
        description: "Magnez to metal ziem alkalicznych, który ma 12 protonów i 12 elektronów.",
        Protons: 12, Neutrons: 12, K: 2, L: 8, M: 2
    ),
    
    // 13: Glin
    Atom(
        name: "Glin",
        number: 13,
        mass: 26.98,
        description: "Glin jest metalem, który ma 13 protonów i 13 elektronów.",
        Protons: 13, Neutrons: 14, K: 2, L: 8, M: 3
    ),
    
    // 14: Krzem
    Atom(
        name: "Krzem",
        number: 14,
        mass: 28.09,
        description: "Krzem jest półmetalem, ma 14 protonów i 14 elektronów.",
        Protons: 14, Neutrons: 14, K: 2, L: 8, M: 4
    ),
    
    // 15: Fosfor
    Atom(
        name: "Fosfor",
        number: 15,
        mass: 30.97,
        description: "Fosfor to pierwiastek w grupie azotowców, ma 15 protonów i 15 elektronów.",
        Protons: 15, Neutrons: 16, K: 2, L: 8, M: 5
    ),
    
    // 16: Siarka
    Atom(
        name: "Siarka",
        number: 16,
        mass: 32.07,
        description: "Siarka to pierwiastek chemiczny, który występuje w wielu związkach.",
        Protons: 16, Neutrons: 16, K: 2, L: 8, M: 6
    ),
    
    // 17: Chlor
    Atom(
        name: "Chlor",
        number: 17,
        mass: 35.45,
        description: "Chlor to gaz halogenowy, bardzo reaktywny, z 17 protonami i 17 elektronami.",
        Protons: 17, Neutrons: 18, K: 2, L: 8, M: 7
    ),
    
    // 18: Argon
    Atom(
        name: "Argon",
        number: 18,
        mass: 39.95,
        description: "Argon to gaz szlachetny, posiadający 18 protonów i 18 elektronów.",
        Protons: 18, Neutrons: 22, K: 2, L: 8, M: 8
    ),
    
    // 19: Potas
    Atom(
        name: "Potas",
        number: 19,
        mass: 39.10,
        description: "Potas jest metalem alkalicznym z 19 protonami i 19 elektronami.",
        Protons: 19, Neutrons: 20, K: 2, L: 8, M: 8, N: 1
    ),

    // 20: Wapń
    Atom(
        name: "Wapń",
        number: 20,
        mass: 40.08,
        description: "Wapń to metal ziem alkalicznych, który odgrywa kluczową rolę w organizmach żywych.",
        Protons: 20, Neutrons: 20, K: 2, L: 8, M: 8, N: 2
    ),
    
    // 21: Skand
    Atom(
        name: "Skand",
        number: 21,
        mass: 44.96,
        description: "Skand to metal przejściowy, ma 21 protonów i 21 elektronów.",
        Protons: 21, Neutrons: 24, K: 2, L: 8, M: 9, N: 2
    ),

    // 22: Tytan
    Atom(
        name: "Tytan",
        number: 22,
        mass: 47.87,
        description: "Tytan to metal przejściowy, który jest szeroko stosowany w przemysłach lotniczym i kosmicznym.",
        Protons: 22, Neutrons: 26, K: 2, L: 8, M: 10, N: 2
    ),
    
    // 23: Wanad
    Atom(
        name: "Wanad",
        number: 23,
        mass: 50.94,
        description: "Wanad to metal przejściowy, wykorzystywany w produkcji stali.",
        Protons: 23, Neutrons: 28, K: 2, L: 8, M: 11, N: 2
    ),
    
    // 24: Chrom
    Atom(
        name: "Chrom",
        number: 24,
        mass: 52.00,
        description: "Chrom to metal przejściowy, znany ze swojej odporności na korozję.",
        Protons: 24, Neutrons: 28, K: 2, L: 8, M: 12, N: 2
    ),

    // 25: Mangan
    Atom(
        name: "Mangan",
        number: 25,
        mass: 54.94,
        description: "Mangan to metal przejściowy, używany w produkcji stopów i baterii.",
        Protons: 25, Neutrons: 30, K: 2, L: 8, M: 13, N: 2
    ),
    
    // 26: Żelazo
    Atom(
        name: "Żelazo",
        number: 26,
        mass: 55.85,
        description: "Żelazo to metal przejściowy, który jest głównym składnikiem stali.",
        Protons: 26, Neutrons: 30, K: 2, L: 8, M: 14, N: 2
    ),
    
    // 27: Kobalt
    Atom(
        name: "Kobalt",
        number: 27,
        mass: 58.93,
        description: "Kobalt to metal przejściowy, który znajduje zastosowanie w bateriach i materiałach magnetycznych.",
        Protons: 27, Neutrons: 32, K: 2, L: 8, M: 15, N: 2
    ),
    
    // 28: Nikiel
    Atom(
        name: "Nikiel",
        number: 28,
        mass: 58.69,
        description: "Nikiel to metal, wykorzystywany w stopach oraz jako materiał magnetyczny.",
        Protons: 28, Neutrons: 31, K: 2, L: 8, M: 16, N: 2
    ),
    
    // 29: Miedź
    Atom(
        name: "Miedź",
        number: 29,
        mass: 63.55,
        description: "Miedź to metal przejściowy, powszechnie używany w przemyśle elektrycznym i elektronicznym.",
        Protons: 29, Neutrons: 35, K: 2, L: 8, M: 18, N: 2
    ),
    
    // 30: Cynk
    Atom(
        name: "Cynk",
        number: 30,
        mass: 65.38,
        description: "Cynk to metal, wykorzystywany głównie do produkcji stopów oraz jako powłoka ochronna.",
        Protons: 30, Neutrons: 35, K: 2, L: 8, M: 18, N: 2
    ),
    
    // 31: Gal
    Atom(
        name: "Gal",
        number: 31,
        mass: 69.72,
        description: "Gal to metal rzadki, który jest używany w elektronice, np. w diodach LED.",
        Protons: 31, Neutrons: 39, K: 2, L: 8, M: 18, N: 3
    ),
    
    // 32: German
    Atom(
        name: "German",
        number: 32,
        mass: 72.63,
        description: "German to półmetal, który znajduje zastosowanie w elektronice i wytwarzaniu półprzewodników.",
        Protons: 32, Neutrons: 41, K: 2, L: 8, M: 18, N: 4
    ),
    
    // 33: Arsen
    Atom(
        name: "Arsen",
        number: 33,
        mass: 74.92,
        description: "Arsen to półmetal, który był używany w medycynie oraz w elektronice.",
        Protons: 33, Neutrons: 42, K: 2, L: 8, M: 18, N: 5
    ),
    
    // 34: Selen
    Atom(
        name: "Selen",
        number: 34,
        mass: 78.96,
        description: "Selen to półmetal, który jest ważnym pierwiastkiem w organizmach żywych.",
        Protons: 34, Neutrons: 45, K: 2, L: 8, M: 18, N: 6
    ),
    
    // 35: Brom
    Atom(
        name: "Brom",
        number: 35,
        mass: 79.90,
        description: "Brom to pierwiastek halogenowy, który ma szerokie zastosowanie w chemii przemysłowej.",
        Protons: 35, Neutrons: 45, K: 2, L: 8, M: 18, N: 7
    ),
    
    // 36: Krypton
    Atom(
        name: "Krypton",
        number: 36,
        mass: 83.80,
        description: "Krypton to gaz szlachetny, który jest wykorzystywany w lampach i zastosowaniach optycznych.",
        Protons: 36, Neutrons: 48, K: 2, L: 8, M: 18, N: 8
    ),

    // 37: Rubid
    Atom(
        name: "Rubid",
        number: 37,
        mass: 85.47,
        description: "Rubid to metal alkaliczny, używany głównie w badaniach naukowych i technologii.",
        Protons: 37, Neutrons: 48, K: 2, L: 8, M: 18, N: 7
    ),

    // 38: Stront
    Atom(
        name: "Stront",
        number: 38,
        mass: 87.62,
        description: "Stront to metal ziem alkalicznych, stosowany w produkcji fajerwerków i materiałów luminescencyjnych.",
        Protons: 38, Neutrons: 50, K: 2, L: 8, M: 18, N: 8
    ),

    // 39: Itr
    Atom(
        name: "Itr",
        number: 39,
        mass: 88.91,
        description: "Itr to metal przejściowy, wykorzystywany w technologii zaawansowanych materiałów.",
        Protons: 39, Neutrons: 50, K: 2, L: 8, M: 18, N: 9
    ),

    // 40: Cyrkon
    Atom(
        name: "Cyrkon",
        number: 40,
        mass: 91.22,
        description: "Cyrkon to metal, który jest szeroko wykorzystywany w produkcji reaktorów jądrowych.",
        Protons: 40, Neutrons: 51, K: 2, L: 8, M: 18, N: 10
    ),

    // 41: Niob
    Atom(
        name: "Niob",
        number: 41,
        mass: 92.91,
        description: "Niob to metal przejściowy, stosowany w produkcji stali nierdzewnej i stopów wysokotemperaturowych.",
        Protons: 41, Neutrons: 52, K: 2, L: 8, M: 18, N: 11
    ),

    // 42: Molibden
    Atom(
        name: "Molibden",
        number: 42,
        mass: 95.95,
        description: "Molibden to metal przejściowy, który znajduje zastosowanie w produkcji stopów odpornych na wysoką temperaturę.",
        Protons: 42, Neutrons: 54, K: 2, L: 8, M: 18, N: 12
    ),

    // 43: Technet
    Atom(
        name: "Technet",
        number: 43,
        mass: 98.00,
        description: "Technet to radioaktywny pierwiastek chemiczny, który jest używany w medycynie.",
        Protons: 43, Neutrons: 55, K: 2, L: 8, M: 18, N: 13
    ),

    // 44: Ruten
    Atom(
        name: "Ruten",
        number: 44,
        mass: 101.1,
        description: "Ruten to metal przejściowy, który wykorzystywany jest w katalizie i produkcji biżuterii.",
        Protons: 44, Neutrons: 57, K: 2, L: 8, M: 18, N: 14
    ),

    // 45: Rod
    Atom(
        name: "Rod",
        number: 45,
        mass: 102.91,
        description: "Rod to metal przejściowy, szeroko stosowany w jubilerstwie.",
        Protons: 45, Neutrons: 58, K: 2, L: 8, M: 18, N: 15
    ),

    // 46: Pallad
    Atom(
        name: "Pallad",
        number: 46,
        mass: 106.42,
        description: "Pallad to metal szlachetny, wykorzystywany w przemyśle motoryzacyjnym i elektronice.",
        Protons: 46, Neutrons: 60, K: 2, L: 8, M: 18, N: 16
    ),

    // 47: Srebro
    Atom(
        name: "Srebro",
        number: 47,
        mass: 107.87,
        description: "Srebro to metal szlachetny, wykorzystywany głównie w jubilerstwie i produkcji monet.",
        Protons: 47, Neutrons: 61, K: 2, L: 8, M: 18, N: 17
    ),

    // 48: Kadm
    Atom(
        name: "Kadm",
        number: 48,
        mass: 112.41,
        description: "Kadm to metal ciężki, który znajduje zastosowanie w akumulatorach i powłokach ochronnych.",
        Protons: 48, Neutrons: 64, K: 2, L: 8, M: 18, N: 18
    ),

    // 49: Ind
    Atom(
        name: "Ind",
        number: 49,
        mass: 114.82,
        description: "Ind to metal rzadki, wykorzystywany w elektronice, zwłaszcza w produkcji ekranów dotykowych.",
        Protons: 49, Neutrons: 66, K: 2, L: 8, M: 18, N: 19
    ),

    // 50: Cyna
    Atom(
        name: "Cyna",
        number: 50,
        mass: 118.71,
        description: "Cyna to metal, który jest wykorzystywany w produkcji lutów i stopów.",
        Protons: 50, Neutrons: 69, K: 2, L: 8, M: 18, N: 20
    ),

    // 51: Antymon
    Atom(
        name: "Antymon",
        number: 51,
        mass: 121.76,
        description: "Antymon to półmetal, który jest wykorzystywany w produkcji półprzewodników.",
        Protons: 51, Neutrons: 71, K: 2, L: 8, M: 18, N: 21
    ),

    // 52: Tellur
    Atom(
        name: "Tellur",
        number: 52,
        mass: 127.60,
        description: "Tellur to półmetal, który znajduje zastosowanie w elektronice oraz w produkcji stopów.",
        Protons: 52, Neutrons: 76, K: 2, L: 8, M: 18, N: 22
    ),

    // 53: Jod
    Atom(
        name: "Jod",
        number: 53,
        mass: 126.90,
        description: "Jod to pierwiastek halogenowy, który jest ważny w medycynie i farmacji.",
        Protons: 53, Neutrons: 74, K: 2, L: 8, M: 18, N: 23
    ),

    // 54: Krypton
    Atom(
        name: "Krypton",
        number: 54,
        mass: 131.29,
        description: "Krypton to gaz szlachetny, który jest wykorzystywany w technologii oświetleniowej.",
        Protons: 54, Neutrons: 77, K: 2, L: 8, M: 18, N: 24
    ),

    // 55: Ces
    Atom(
        name: "Ces",
        number: 55,
        mass: 132.91,
        description: "Ces to metal alkaliczny, który jest wykorzystywany w lampach gazowych oraz w produkcji energii.",
        Protons: 55, Neutrons: 78, K: 2, L: 8, M: 18, N: 23
    ),

    // 56: Bar
    Atom(
        name: "Bar",
        number: 56,
        mass: 137.33,
        description: "Bar to metal ziem alkalicznych, który jest używany w produkcji stopów i materiałów szklarskich.",
        Protons: 56, Neutrons: 81, K: 2, L: 8, M: 18, N: 24
    ),

    // 57: Lantan
    Atom(
        name: "Lantan",
        number: 57,
        mass: 138.91,
        description: "Lantan to metal ziem rzadkich, który znajduje zastosowanie w produkcji stopów oraz w elektronice.",
        Protons: 57, Neutrons: 82, K: 2, L: 8, M: 18, N: 25
    ),

    // 58: Ceryt
    Atom(
        name: "Ceryt",
        number: 58,
        mass: 140.12,
        description: "Ceryt to metal ziem rzadkich, stosowany głównie w technologii nuklearnej.",
        Protons: 58, Neutrons: 82, K: 2, L: 8, M: 18, N: 26
    ),

    // 59: Praseodym
    Atom(
        name: "Praseodym",
        number: 59,
        mass: 140.91,
        description: "Praseodym to metal ziem rzadkich, wykorzystywany w produkcji stopów i magnesów.",
        Protons: 59, Neutrons: 82, K: 2, L: 8, M: 18, N: 27
    ),

    // 60: Neodym
    Atom(
        name: "Neodym",
        number: 60,
        mass: 144.24,
        description: "Neodym to metal ziem rzadkich, stosowany głównie w produkcji silnych magnesów.",
        Protons: 60, Neutrons: 84, K: 2, L: 8, M: 18, N: 28
    ),

    // 61: Promet
    Atom(
        name: "Promet",
        number: 61,
        mass: 145.00,
        description: "Promet to radioaktywny pierwiastek, wykorzystywany w specjalnych źródłach światła.",
        Protons: 61, Neutrons: 84, K: 2, L: 8, M: 18, N: 29
    ),

    // 62: Samary
    Atom(
        name: "Samary",
        number: 62,
        mass: 150.36,
        description: "Samary to metal ziem rzadkich, stosowany w reaktorach jądrowych i w produkcji baterii.",
        Protons: 62, Neutrons: 88, K: 2, L: 8, M: 18, N: 30
    ),

    // 63: Europ
    Atom(
        name: "Europ",
        number: 63,
        mass: 151.98,
        description: "Europ to metal ziem rzadkich, wykorzystywany w produkcji lamp fluorescencyjnych.",
        Protons: 63, Neutrons: 89, K: 2, L: 8, M: 18, N: 31
    ),

    // 64: Gadolinium
    Atom(
        name: "Gadolinium",
        number: 64,
        mass: 157.25,
        description: "Gadolinium to metal ziem rzadkich, wykorzystywany w obrazowaniu medycznym i w reaktorach jądrowych.",
        Protons: 64, Neutrons: 93, K: 2, L: 8, M: 18, N: 32
    ),

    // 65: Terb
    Atom(
        name: "Terb",
        number: 65,
        mass: 158.93,
        description: "Terb to metal ziem rzadkich, wykorzystywany w produkcji elektroniki i technologii oświetleniowej.",
        Protons: 65, Neutrons: 94, K: 2, L: 8, M: 18, N: 33
    ),

    // 66: Dysproz
    Atom(
        name: "Dysproz",
        number: 66,
        mass: 162.50,
        description: "Dysproz to metal ziem rzadkich, używany w produkcji silnych magnesów i urządzeń elektrycznych.",
        Protons: 66, Neutrons: 97, K: 2, L: 8, M: 18, N: 34
    ),

    // 67: Holm
    Atom(
        name: "Holm",
        number: 67,
        mass: 164.93,
        description: "Holm to metal ziem rzadkich, stosowany w produkcji magnesów oraz w elektronice.",
        Protons: 67, Neutrons: 98, K: 2, L: 8, M: 18, N: 35
    ),

    // 68: Erb
    Atom(
        name: "Erb",
        number: 68,
        mass: 167.26,
        description: "Erb to metal ziem rzadkich, używany w produkcji lasery i telekomunikacji.",
        Protons: 68, Neutrons: 99, K: 2, L: 8, M: 18, N: 36
    ),

    // 69: Tuli
    Atom(
        name: "Tuli",
        number: 69,
        mass: 168.93,
        description: "Tuli to metal ziem rzadkich, stosowany w produkcji materiałów magnetycznych.",
        Protons: 69, Neutrons: 100, K: 2, L: 8, M: 18, N: 37
    ),

    // 70: Iterb
    Atom(
        name: "Iterb",
        number: 70,
        mass: 173.04,
        description: "Iterb to metal ziem rzadkich, wykorzystywany w telekomunikacji i materiałach optycznych.",
        Protons: 70, Neutrons: 103, K: 2, L: 8, M: 18, N: 38
    ),

    // 71: Lutet
    Atom(
        name: "Lutet",
        number: 71,
        mass: 174.97,
        description: "Lutet to metal ziem rzadkich, stosowany w technologii próżniowej i w stopach wysokotemperaturowych.",
        Protons: 71, Neutrons: 104, K: 2, L: 8, M: 18, N: 39
    ),

    // 72: Hafn
    Atom(
        name: "Hafn",
        number: 72,
        mass: 178.49,
        description: "Hafn to metal przejściowy, stosowany głównie w reaktorach jądrowych i stopach wysokotemperaturowych.",
        Protons: 72, Neutrons: 106, K: 2, L: 8, M: 18, N: 34
    ),

    // 73: Tantal
    Atom(
        name: "Tantal",
        number: 73,
        mass: 180.95,
        description: "Tantal to metal przejściowy, wykorzystywany w produkcji elektroniki, szczególnie kondensatorów.",
        Protons: 73, Neutrons: 108, K: 2, L: 8, M: 18, N: 31
    ),

    // 74: Wolfram
    Atom(
        name: "Wolfram",
        number: 74,
        mass: 183.84,
        description: "Wolfram to metal przejściowy, stosowany w produkcji żarników, elektrod i materiałów o wysokiej temperaturze topnienia.",
        Protons: 74, Neutrons: 110, K: 2, L: 8, M: 18, N: 32
    ),

    // 75: Ren
    Atom(
        name: "Ren",
        number: 75,
        mass: 186.21,
        description: "Ren to metal przejściowy, wykorzystywany w elektronice, materiałach magnetycznych i katalizie.",
        Protons: 75, Neutrons: 111, K: 2, L: 8, M: 18, N: 32, O: 1
    ),

    // 76: Osm
    Atom(
        name: "Osm",
        number: 76,
        mass: 190.23,
        description: "Osm to metal przejściowy, stosowany w produkcji kontaktów elektrycznych i w stopach o wysokiej twardości.",
        Protons: 76, Neutrons: 114, K: 2, L: 8, M: 18, N: 32, O: 2
    ),

    // 77: Iridium
    Atom(
        name: "Iridium",
        number: 77,
        mass: 192.22,
        description: "Iridium to metal przejściowy, stosowany w produkcji stopów odpornych na wysokie temperatury.",
        Protons: 77, Neutrons: 115, K: 2, L: 8, M: 18, N: 32, O: 3
    ),

    // 78: Platyna
    Atom(
        name: "Platyna",
        number: 78,
        mass: 195.08,
        description: "Platyna to metal szlachetny, wykorzystywany w przemyśle chemicznym i jubilerskim.",
        Protons: 78, Neutrons: 117, K: 2, L: 8, M: 18, N: 32, O: 4
    ),

    // 79: Złoto
    Atom(
        name: "Złoto",
        number: 79,
        mass: 196.97,
        description: "Złoto to metal szlachetny, wykorzystywany głównie w jubilerstwie oraz elektronice.",
        Protons: 79, Neutrons: 118, K: 2, L: 8, M: 18, N: 32, O: 5
    ),

    // 80: Rtęć
    Atom(
        name: "Rtęć",
        number: 80,
        mass: 200.59,
        description: "Rtęć to metal cieczy w temperaturze pokojowej, stosowany w termometrach i w technologii oświetleniowej.",
        Protons: 80, Neutrons: 121, K: 2, L: 8, M: 18, N: 32, O: 6
    ),

    // 81: Tal
    Atom(
        name: "Tal",
        number: 81,
        mass: 204.38,
        description: "Tal to metal rzadki, wykorzystywany w produkcji półprzewodników oraz w radioaktywnych źródłach ciepła.",
        Protons: 81, Neutrons: 123, K: 2, L: 8, M: 18, N: 32, O: 7
    ),

    // 82: Ołów
    Atom(
        name: "Ołów",
        number: 82,
        mass: 207.2,
        description: "Ołów to metal ciężki, wykorzystywany w akumulatorach, osłonach przed promieniowaniem i w produkcji farb.",
        Protons: 82, Neutrons: 125, K: 2, L: 8, M: 18, N: 32, O: 8
    ),

    // 83: Bizmut
    Atom(
        name: "Bizmut",
        number: 83,
        mass: 208.98,
        description: "Bizmut to metal ciężki, stosowany w produkcji stopów o niskiej temperaturze topnienia.",
        Protons: 83, Neutrons: 126, K: 2, L: 8, M: 18, N: 32, O: 9
    ),

    // 84: Polon
    Atom(
        name: "Polon",
        number: 84,
        mass: 209.98,
        description: "Polon to pierwiastek radioaktywny, wykorzystywany w źródłach ciepła oraz w badaniach jądrowych.",
        Protons: 84, Neutrons: 126, K: 2, L: 8, M: 18, N: 32, O: 10
    ),

    // 85: Astat
    Atom(
        name: "Astat",
        number: 85,
        mass: 210.00,
        description: "Astat to pierwiastek radioaktywny, stosowany w leczeniu nowotworów i w badaniach medycznych.",
        Protons: 85, Neutrons: 125, K: 2, L: 8, M: 18, N: 32, O: 11
    ),

    // 86: Radon
    Atom(
        name: "Radon",
        number: 86,
        mass: 222.00,
        description: "Radon to pierwiastek radioaktywny, gaz szlachetny, wykorzystywany w terapii nowotworowej.",
        Protons: 86, Neutrons: 136, K: 2, L: 8, M: 18, N: 32, O: 12
    ),

    // 87: Franc
    Atom(
        name: "Franc",
        number: 87,
        mass: 223.00,
        description: "Franc to rzadki, radioaktywny metal alkaliowy, stosowany w badaniach jądrowych.",
        Protons: 87, Neutrons: 136, K: 2, L: 8, M: 18, N: 32, O: 14
    ),
    
    // 88: Rad
    Atom(
        name: "Rad",
        number: 88,
        mass: 226.00,
        description: "Rad to pierwiastek radioaktywny, wykorzystywany w terapii nowotworowej oraz w badaniach naukowych.",
        Protons: 88, Neutrons: 138, K: 2, L: 8, M: 18, N: 32, O: 15
    ),

    // 89: Aktyn
    Atom(
        name: "Aktyn",
        number: 89,
        mass: 227.00,
        description: "Aktyn to pierwiastek radioaktywny, wykorzystywany w badaniach jądrowych i technologii energetycznych.",
        Protons: 89, Neutrons: 138, K: 2, L: 8, M: 18, N: 32, O: 16
    ),
    
    // 90: Tor
    Atom(
        name: "Tor",
        number: 90,
        mass: 232.04,
        description: "Tor to pierwiastek radioaktywny, stosowany w energetyce jądrowej i produkcji materiałów napromieniowanych.",
        Protons: 90, Neutrons: 142, K: 2, L: 8, M: 18, N: 32, O: 17
    ),
    
    // 91: Protaktyn
    Atom(
        name: "Protaktyn",
        number: 91,
        mass: 231.04,
        description: "Protaktyn to pierwiastek radioaktywny, stosowany w technologii jądrowej.",
        Protons: 91, Neutrons: 140, K: 2, L: 8, M: 18, N: 32, O: 18
    ),

    // 92: Uran
    Atom(
        name: "Uran",
        number: 92,
        mass: 238.03,
        description: "Uran to pierwiastek radioaktywny, szeroko stosowany w energetyce jądrowej, zwłaszcza w reaktorach jądrowych.",
        Protons: 92, Neutrons: 146, K: 2, L: 8, M: 18, N: 32, O: 19
    ),

    // 93: Neptun
    Atom(
        name: "Neptun",
        number: 93,
        mass: 237.00,
        description: "Neptun to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych oraz w produkcji materiałów radioaktywnych.",
        Protons: 93, Neutrons: 144, K: 2, L: 8, M: 18, N: 32, O: 20
    ),

    // 94: Pluton
    Atom(
        name: "Pluton",
        number: 94,
        mass: 244.00,
        description: "Pluton to pierwiastek sztuczny, wykorzystywany w reaktorach jądrowych i produkcji broni jądrowych.",
        Protons: 94, Neutrons: 150, K: 2, L: 8, M: 18, N: 32, O: 21
    ),
    
    // 95: Ameryk
    Atom(
        name: "Ameryk",
        number: 95,
        mass: 243.00,
        description: "Ameryk to pierwiastek sztuczny, stosowany w medycynie nuklearnej i badaniach jądrowych.",
        Protons: 95, Neutrons: 148, K: 2, L: 8, M: 18, N: 32, O: 22
    ),

    // 96: Kur
    Atom(
        name: "Kur",
        number: 96,
        mass: 247.00,
        description: "Kur to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych i jako materiał reaktorowy.",
        Protons: 96, Neutrons: 151, K: 2, L: 8, M: 18, N: 32, O: 23
    ),
    
    // 97: Berkel
    Atom(
        name: "Berkel",
        number: 97,
        mass: 247.00,
        description: "Berkel to pierwiastek sztuczny, używany w badaniach jądrowych.",
        Protons: 97, Neutrons: 150, K: 2, L: 8, M: 18, N: 32, O: 24
    ),
    
    // 98: Kaliforn
    Atom(
        name: "Kaliforn",
        number: 98,
        mass: 251.00,
        description: "Kaliforn to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych.",
        Protons: 98, Neutrons: 153, K: 2, L: 8, M: 18, N: 32, O: 25
    ),

    // 99: Einsteinium
    Atom(
        name: "Einsteinium",
        number: 99,
        mass: 252.00,
        description: "Einsteinium to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych i produkcji elementów radioaktywnych.",
        Protons: 99, Neutrons: 153, K: 2, L: 8, M: 18, N: 32, O: 26
    ),
    
    // 100: Ferm
    Atom(
        name: "Ferm",
        number: 100,
        mass: 257.00,
        description: "Ferm to pierwiastek sztuczny, stosowany w badaniach jądrowych i syntezach jądrowych.",
        Protons: 100, Neutrons: 157, K: 2, L: 8, M: 18, N: 32, O: 27
    ),
    
    // 101: Mendelewium
    Atom(
        name: "Mendelewium",
        number: 101,
        mass: 258.00,
        description: "Mendelewium to pierwiastek sztuczny, stosowany w badaniach jądrowych.",
        Protons: 101, Neutrons: 157, K: 2, L: 8, M: 18, N: 32, O: 28
    ),
    
    // 102: Nobelium
    Atom(
        name: "Nobelium",
        number: 102,
        mass: 259.00,
        description: "Nobelium to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych.",
        Protons: 102, Neutrons: 157, K: 2, L: 8, M: 18, N: 32, O: 29
    ),

    // 103: Lawrencium
    Atom(
        name: "Lawrencium",
        number: 103,
        mass: 262.00,
        description: "Lawrencium to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych.",
        Protons: 103, Neutrons: 159, K: 2, L: 8, M: 18, N: 32, O: 30
    ),

    // 104: Rutherfordium
    Atom(
        name: "Rutherfordium",
        number: 104,
        mass: 267.00,
        description: "Rutherfordium to pierwiastek sztuczny, stosowany w badaniach jądrowych.",
        Protons: 104, Neutrons: 163, K: 2, L: 8, M: 18, N: 32, O: 31
    ),

    // 105: Dubnium
    Atom(
        name: "Dubnium",
        number: 105,
        mass: 270.00,
        description: "Dubnium to pierwiastek sztuczny, odkryty w laboratorium, wykorzystywany w badaniach jądrowych.",
        Protons: 105, Neutrons: 162, K: 2, L: 8, M: 18, N: 32, O: 32
    ),
    
    // 106: Seaborgium
    Atom(
        name: "Seaborgium",
        number: 106,
        mass: 271.00,
        description: "Seaborgium to pierwiastek sztuczny, nazwany na cześć Glenna Seaborga, wykorzystywany w badaniach jądrowych.",
        Protons: 106, Neutrons: 165, K: 2, L: 8, M: 18, N: 32, O: 33
    ),
    
    // 107: Bohrium
    Atom(
        name: "Bohrium",
        number: 107,
        mass: 270.00,
        description: "Bohrium to pierwiastek sztuczny, odkryty w 1980 roku, wykorzystywany w badaniach jądrowych.",
        Protons: 107, Neutrons: 161, K: 2, L: 8, M: 18, N: 32, O: 34
    ),

    // 108: Hassium
    Atom(
        name: "Hassium",
        number: 108,
        mass: 277.00,
        description: "Hassium to pierwiastek sztuczny, wykorzystywany głównie w badaniach jądrowych.",
        Protons: 108, Neutrons: 169, K: 2, L: 8, M: 18, N: 32, O: 35
    ),

    // 109: Meitnerium
    Atom(
        name: "Meitnerium",
        number: 109,
        mass: 278.00,
        description: "Meitnerium to pierwiastek sztuczny, odkryty w latach 80-tych XX wieku, wykorzystywany w badaniach jądrowych.",
        Protons: 109, Neutrons: 169, K: 2, L: 8, M: 18, N: 32, O: 36
    ),
    
    // 110: Darmstadtium
    Atom(
        name: "Darmstadtium",
        number: 110,
        mass: 281.00,
        description: "Darmstadtium to pierwiastek sztuczny, wykorzystywany w badaniach jądrowych, odkryty w Niemczech.",
        Protons: 110, Neutrons: 171, K: 2, L: 8, M: 18, N: 32, O: 37
    ),

    // 111: Roentgenium
    Atom(
        name: "Roentgenium",
        number: 111,
        mass: 280.00,
        description: "Roentgenium to pierwiastek sztuczny, nazwany na cześć Wilhelma Roentgena, odkryty w 1994 roku.",
        Protons: 111, Neutrons: 169, K: 2, L: 8, M: 18, N: 32, O: 38
    ),

    // 112: Copernicium
    Atom(
        name: "Copernicium",
        number: 112,
        mass: 285.00,
        description: "Copernicium to pierwiastek sztuczny, odkryty w Niemczech, nazwany na cześć Mikołaja Kopernika.",
        Protons: 112, Neutrons: 173, K: 2, L: 8, M: 18, N: 32, O: 39
    ),

    // 113: Nihonium
    Atom(
        name: "Nihonium",
        number: 113,
        mass: 284.00,
        description: "Nihonium to pierwiastek sztuczny, odkryty przez japońskich naukowców w 2004 roku.",
        Protons: 113, Neutrons: 171, K: 2, L: 8, M: 18, N: 32, O: 40
    ),

    // 114: Flerovium
    Atom(
        name: "Flerovium",
        number: 114,
        mass: 289.00,
        description: "Flerovium to pierwiastek sztuczny, nazwany na cześć Flerova, rosyjskiego naukowca.",
        Protons: 114, Neutrons: 175, K: 2, L: 8, M: 18, N: 32, O: 41
    ),

    // 115: Moscovium
    Atom(
        name: "Moscovium",
        number: 115,
        mass: 288.00,
        description: "Moscovium to pierwiastek sztuczny, odkryty w Rosji, nazwany na cześć Moskwy.",
        Protons: 115, Neutrons: 173, K: 2, L: 8, M: 18, N: 32, O: 42
    ),

    // 116: Livermorium
    Atom(
        name: "Livermorium",
        number: 116,
        mass: 293.00,
        description: "Livermorium to pierwiastek sztuczny, nazwany na cześć Laboratorium Livermore w Stanach Zjednoczonych.",
        Protons: 116, Neutrons: 177, K: 2, L: 8, M: 18, N: 32, O: 43
    ),
    
    // 117: Tenessine
    Atom(
        name: "Tenessine",
        number: 117,
        mass: 294.00,
        description: "Tenessine to pierwiastek sztuczny, nazwany na cześć stanu Tennessee, gdzie przeprowadzono badania.",
        Protons: 117, Neutrons: 177, K: 2, L: 8, M: 18, N: 32, O: 44
    ),
    
    // 118: Oganesson
    Atom(
        name: "Oganesson",
        number: 118,
        mass: 294.00,
        description: "Oganesson to pierwiastek sztuczny, nazwany na cześć rosyjskiego fizyka Jory Oganessiana.",
        Protons: 118, Neutrons: 176, K: 2, L: 8, M: 18, N: 32, O: 45
    )
]


    
    

//let Atoms: [Atom] = [
//    Atom(),
//    // Wodór
//    Atom(
//        name: "Wodór",
//        number: 1,
//        mass: 1.0,
//        description: "Najprostszy atom, składa się z jednego protonu i jednego elektronu.",
//        particles: [
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 0*speed),
//            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.15 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1*speed)
//        ]
//    ),
//    // Hel
//    Atom(
//        name: "Hel",
//        number: 2,
//        mass: 4.0,
//        description: "Atom helu, składający się z dwóch protonów, dwóch neutronów i dwóch elektronów.",
//        particles: [
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, 0.0), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, 0.0), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, 0.05, 0.05), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, -0.05, -0.05), orbitSpeed: 0),
//            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.25 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1 * speed, orbitTimeOffset: 0),
//            Particle(name: "Electron", textureName: "electron", radius: 0.02 * scale, orbitRadius: 0.25 * scale, orbitCenter: SIMD3<Float>(0,0,0), orbitSpeed: 1 * speed, orbitTimeOffset: 1)
//        ]
//
//    ),
//    // Węgiel
//    Atom(
//        name: "Węgiel",
//        number: 6,
//        mass: 12.0,
//        description: "Atom węgla, składający się z sześciu protonów, sześciu neutronów i sześciu elektronów.",
//        particles: [
//            // Protony
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, 0.05), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, 0.05), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, 0.05, -0.05), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, -0.05, -0.05), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.07, 0.00), orbitSpeed: 0),
//            Particle(name: "Proton", textureName: "proton", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, -0.07, 0.00), orbitSpeed: 0),
//
//            // Neutrony
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.07, 0.00, 0.00), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.07, 0.00, 0.00), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.00, 0.07), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.00, 0.00, -0.07), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>( 0.05, 0.05, -0.05), orbitSpeed: 0),
//            Particle(name: "Neutron", textureName: "neutron", radius: 0.1 * scale, orbitRadius: 0, orbitCenter: SIMD3<Float>(-0.05, -0.05, -0.05), orbitSpeed: 0),
//
//            // Elektrony
//            
//        ] + generateElectrons(K: 2, L: 4)
//    )
//]
//
//

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

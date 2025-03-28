//
//  SolarSystemPlanets.swift
//  SphereAR
//
//  Created by Rafał Michałowski on 20/03/2025.
//

import RealityKit  // Umożliwia korzystanie z klas i funkcji do tworzenia i manipulowania encjami 3D, materiałami itp.
import simd       // Dostarcza typy matematyczne (np. SIMD3<Float>) oraz operacje na wektorach i kwaternionach, które są wykorzystywane do obliczeń transformacji

// MARK: - Parametry Ziemi (można je zmieniać)
let earthOrbitRadiusConstant: Float = 0.5      // Promień orbity Ziemi w metrach
let earthPlanetRadiusConstant: Float = 0.1       // Promień Ziemi w metrach
let earthOrbitPeriod: Float = 10                 // Czas pełnego ruchu orbity Ziemi w sekundach
let earthSelfRotationPeriod: Float = 2           // Czas pełnego obrotu Ziemi wokół własnej osi w sekundach

// Obliczanie prędkości Ziemi
let earthOrbitSpeedConstant: Float = (2 * Float.pi) / earthOrbitPeriod       // Prędkość orbitalna (2π/T)
let earthSelfRotationSpeedConstant: Float = (2 * Float.pi) / earthSelfRotationPeriod // Prędkość obrotu wokół własnej osi

// MARK: - Funkcja pomocnicza do obliczania prędkości orbitalnej dla innych planet
func orbitalSpeed(relativeDistance: Float) -> Float {
    // Prawo Keplera: okres orbity T ∝ r^(3/2)
    let period = earthOrbitPeriod * pow(relativeDistance, 1.5)
    return (2 * Float.pi) / period
}

let sunPlanetRadiusConstant: Float = 0.12

// MARK: - Lista planet układu słonecznego
// Przyjmujemy, że orbitRadius innych planet jest skalowany względem Ziemi (0.5 m odpowiada 1 AU)
// a orbitSpeed obliczamy z zależności T ∝ r^(3/2)
let solarSystemPlanets: [Planet] = [
    Planet(
        name: "Sun",
        textureName: "sun",  // Upewnij się, że masz zasób tekstury o nazwie "sun" w zasobach projektu
        radius: sunPlanetRadiusConstant,
        orbitRadius: 0,              // Słońce znajduje się w centrum
        orbitSpeed: 0,
        selfRotationSpeed: 0,
        planetInformation:
            PlanetInformation(
                name:"Słońce",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras pretium sagittis maximus. Phasellus sit amet pulvinar turpis. Quisque condimentum quis libero et vulputate. Curabitur interdum lacus sit amet mauris porttitor, in finibus libero sagittis. Nam neque est, mollis at ante sed, mattis sollicitudin ex. Cras nec ante quis diam faucibus pretium. Phasellus pellentesque sagittis semper. Quisque auctor orci porttitor ex dignissim, ut lobortis libero suscipit. Aliquam aliquam, neque quis tincidunt pulvinar, diam justo tempor urna, ut suscipit ex turpis id elit. Ut aliquam vitae est quis viverra. Proin enim eros, pretium id maximus at, lacinia id massa. Cras maximus neque eros, ac cursus enim consequat vehicula. Sed purus tellus, auctor id purus eu, dictum rhoncus tellus. Vivamus ut sem congue arcu rhoncus suscipit.",
                radius: "657tys. km",
                mass:"1.9*10^30 kg"
            )
    ),
    Planet(
        name: "Mercury",
        textureName: "mercury",
        radius: 0.05,
        orbitRadius: earthOrbitRadiusConstant * 0.39,  // ≈ 0.195 m
        orbitSpeed: orbitalSpeed(relativeDistance: 0.39),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Merkury",
                description: "Najmniejsza i najbliższa Słońcu planeta. Ma skalistą powierzchnię pokrytą kraterami i prawie nie ma atmosfery. Temperatury wahają się od -180°C w nocy do 430°C w dzień.",
                radius: "2 493 km",
                mass:"3.3*10^23 kg"
            )
    ),
    Planet(
        name: "Venus",
        textureName: "venus",
        radius: 0.09,
        orbitRadius: earthOrbitRadiusConstant * 0.723, // ≈ 0.3615 m
        orbitSpeed: orbitalSpeed(relativeDistance: 0.723),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Wenus",
                description: "Najgorętsza planeta Układu Słonecznego ze względu na gęstą atmosferę z dwutlenku węgla, która powoduje efekt cieplarniany. Powierzchnia pokryta jest wulkanami i gęstymi chmurami kwasu siarkowego.",
                radius: "6 051 km",
                mass:"4.86*10^24 kg"
            )
    ),
    Planet(
        name: "Earth",
        textureName: "earth",
        radius: earthPlanetRadiusConstant,
        orbitRadius: earthOrbitRadiusConstant,
        orbitSpeed: earthOrbitSpeedConstant,
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Ziemia",
                description: "Jedyna planeta, na której istnieje życie. Posiada wodę w stanie ciekłym, tlen w atmosferze i różnorodne ekosystemy. Ma jednego naturalnego satelitę – Księżyc.",
                radius: "6 371 km",
                mass:"5.9*10^24 kg"
            )
    ),
    Planet(
        name: "Mars",
        textureName: "mars",
        radius: 0.07,
        orbitRadius: earthOrbitRadiusConstant * 1.524, // ≈ 0.762 m
        orbitSpeed: orbitalSpeed(relativeDistance: 1.524),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Mars",
                description: "Czerwona planeta, znana z obecności tlenków żelaza na powierzchni. Posiada najwyższą górę w Układzie Słonecznym – Olympus Mons. Na Marsie znaleziono ślady wody, co może wskazywać na istnienie dawnych form życia.",
                radius: "3 396 km",
                mass:"6.4*10^23 kg"
            )
    ),
    Planet(
        name: "Jupiter",
        textureName: "jupiter",
        radius: 0.2,
        orbitRadius: earthOrbitRadiusConstant * 5.203, // ≈ 2.6015 m
        orbitSpeed: orbitalSpeed(relativeDistance: 5.203),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Jowisz",
                description: "Największa planeta Układu Słonecznego, gazowy olbrzym z charakterystycznym Wielkim Czerwonym Punktem – gigantycznym huraganem. Ma ponad 90 księżyców, w tym Europę, która może skrywać ocean pod lodową powierzchnią.",
                radius: "71 492 km",
                mass:"1,9*10^27 kg"
            )
    ),
    Planet(
        name: "Saturn",
        textureName: "saturn",
        radius: 0.18,
        orbitRadius: earthOrbitRadiusConstant * 9.537, // ≈ 4.7685 m
        orbitSpeed: orbitalSpeed(relativeDistance: 9.537),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Saturn",
                description: "Znany ze swoich imponujących pierścieni zbudowanych z lodu i skał. Jest gazowym olbrzymem o ponad 80 księżycach, w tym Tytanie, który ma własną atmosferę i jeziora z ciekłego metanu.",
                radius: "58 232 km",
                mass:"5.6*10^26"
            )
    ),
    Planet(
        name: "Uranus",
        textureName: "uranus",
        radius: 0.16,
        orbitRadius: earthOrbitRadiusConstant * 19.191, // ≈ 9.5955 m
        orbitSpeed: orbitalSpeed(relativeDistance: 19.191),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Uran",
                description: "Lodowy olbrzym o charakterystycznym niebiesko-zielonym kolorze spowodowanym metanem w atmosferze. Obraca się na boku, co czyni go wyjątkowym wśród planet.",
                radius: "25 362 km",
                mass:"8.6*10^25"
            )
    ),
    Planet(
        name: "Neptune",
        textureName: "neptune",
        radius: 0.16,
        orbitRadius: earthOrbitRadiusConstant * 30.07,  // ≈ 15.035 m
        orbitSpeed: orbitalSpeed(relativeDistance: 30.07),
        selfRotationSpeed: earthSelfRotationSpeedConstant,
        planetInformation:
            PlanetInformation(
                name:"Neptun",
                description: "Najdalsza planeta Układu Słonecznego, posiada najsilniejsze wiatry spośród wszystkich planet. Jest głównie zbudowana z lodu i gazów, a jej największy księżyc, Tryton, porusza się w kierunku przeciwnym do obrotu planety.",
                radius: "20",
                mass:"10"
            )
    )
]


/*
import RealityKit
import simd

// Lista planet w układzie słonecznym, przy czym wartości orbit przeskalowano do układu, w którym Ziemia ma orbitę o promieniu 0.5 m
let solarSystemPlanets: [Planet] = [
    Planet(
        name: "Mercury",
        textureName: "mercury",
        radius: 0.05,
        orbitRadius: 0.5 * 0.39, // ≈ 0.195 m
        orbitSpeed: 2.59,        // 2π / T, gdzie T ≈ 2.43 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Venus",
        textureName: "venus",
        radius: 0.09,
        orbitRadius: 0.5 * 0.723, // ≈ 0.3615 m
        orbitSpeed: 1.02,         // T ≈ 6.16 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Earth",
        textureName: "earth",
        radius: 0.1,
        orbitRadius: 0.5,         // 0.5 m
        orbitSpeed: 0.628,        // T = 10 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Mars",
        textureName: "mars",
        radius: 0.07,
        orbitRadius: 0.5 * 1.524, // ≈ 0.762 m
        orbitSpeed: 0.333,        // T ≈ 18.84 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Jupiter",
        textureName: "jupiter",
        radius: 0.2,
        orbitRadius: 0.5 * 5.203, // ≈ 2.6015 m
        orbitSpeed: 0.053,        // T ≈ 118.4 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Saturn",
        textureName: "saturn",
        radius: 0.18,
        orbitRadius: 0.5 * 9.537, // ≈ 4.7685 m
        orbitSpeed: 0.0213,       // T ≈ 294.6 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Uranus",
        textureName: "uranus",
        radius: 0.16,
        orbitRadius: 0.5 * 19.191, // ≈ 9.5955 m
        orbitSpeed: 0.00748,       // T ≈ 840.7 s
        selfRotationSpeed: .pi
    ),
    Planet(
        name: "Neptune",
        textureName: "neptune",
        radius: 0.16,
        orbitRadius: 0.5 * 30.07,  // ≈ 15.035 m
        orbitSpeed: 0.00380,       // T ≈ 1652.9 s
        selfRotationSpeed: .pi
    )
]
*/

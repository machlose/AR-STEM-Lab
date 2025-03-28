//
//  ARViewContainer.swift
//  SphereAR
//
//  Created by Rafał Michałowski on 20/03/2025.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    // Binding do wybranej planety – przekazujemy tę wartość do ContentView
    @Binding var selectedPlanet: Planet?

    class Coordinator: NSObject {
        var cancellable: Cancellable?
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        // Główna kotwica układu planetarnego
        var planetaryAnchor: AnchorEntity?
        // Flaga określająca, czy jesteśmy w trybie "zoom"
        var isZoomed = false
        // Zapamiętany oryginalny transform kotwicy, aby móc przywrócić stan
        var originalTransform: Transform?
        // Zapamiętany czas symulacji w momencie freeze (orbitalny ruch zamrożony)
        var freezeTime: Float = 0.0
        
        // Binding do wybranej planety – przekazany z ARViewContainer
        var selectedPlanetBinding: Binding<Planet?>
        
        init(selectedPlanet: Binding<Planet?>) {
            self.selectedPlanetBinding = selectedPlanet
        }
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            guard let arView = self.arView,
                  let planetaryAnchor = self.planetaryAnchor else { return }
            
            let tapLocation = recognizer.location(in: arView)
            print("Dotknięto ekranu")
            
            // Wykonujemy hit-test – korzystamy z pierwszego wyniku
            if let result = arView.hitTest(tapLocation, query: .nearest, mask: .all).first,
               let tappedEntity = result.entity as? ModelEntity {
                print("Dotknięto obiekt: \(tappedEntity.name)")
                
                // Pobieramy bieżący transform kamery
                let cameraTransform = arView.cameraTransform
                let cameraMatrix = cameraTransform.matrix
                
                // Pozycja kamery
                let cameraPosition = SIMD3<Float>(
                    cameraMatrix.columns.3.x,
                    cameraMatrix.columns.3.y,
                    cameraMatrix.columns.3.z
                )
                // Wektor forward – ARKit ustawia kamerę, aby patrzyła w kierunku ujemnej osi Z
                let cameraForward = -SIMD3<Float>(
                    cameraMatrix.columns.2.x,
                    cameraMatrix.columns.2.y,
                    cameraMatrix.columns.2.z
                )
                
                // Docelowa pozycja: 0.5 m przed kamerą
                let desiredWorldPosition = cameraPosition + cameraForward * 0.5
                
                // Pobieramy bieżącą pozycję klikniętego obiektu w przestrzeni świata
                let currentWorldPosition = result.position
                
                // Obliczamy przesunięcie (delta)
                let delta = desiredWorldPosition - currentWorldPosition
                
                // Sprawdzamy, czy obiekt jest przed kamerą
                let directionToObject = normalize(currentWorldPosition - cameraPosition)
                let dotValue = dot(directionToObject, cameraForward)
                if dotValue < 0 {
                    print("Obiekt znajduje się za kamerą – zoom nie zostanie wykonany.")
                    return
                }
                
                if !isZoomed {
                    // Przechowujemy bieżący czas symulacji jako freezeTime
                    freezeTime = Float(accumulatedTime)
                    // Zapamiętujemy oryginalny transform kotwicy
                    originalTransform = planetaryAnchor.transform
                    
                    // Ustawiamy wybraną planetę w bindingu, aby overlay z informacjami się pojawił.
                    // Zakładamy, że nazwa obiektu odpowiada nazwie planety.
                    print(tappedEntity)
                    if let tappedPlanet = planets.first(where: { $0.name == tappedEntity.name }) {
                        selectedPlanetBinding.wrappedValue = tappedPlanet
                    }
                    
                    // Nie przerywamy subskrypcji – pozwalamy na ciągłą aktualizację obracania.
                    var newTransform = planetaryAnchor.transform
                    newTransform.translation += delta
                    
                    planetaryAnchor.move(
                        to: newTransform,
                        relativeTo: planetaryAnchor.parent,
                        duration: 0.5,
                        timingFunction: .easeInOut
                    )
                    
                    isZoomed = true
                    print("isZoomed: true, freezeTime: \(freezeTime)")
                } else {
                    // Przywracamy oryginalny transform kotwicy
                    if let original = originalTransform {
                        planetaryAnchor.move(
                            to: original,
                            relativeTo: planetaryAnchor.parent,
                            duration: 0.5,
                            timingFunction: .easeInOut
                        )
                    }
                    // Resetujemy symulację – ustawiamy accumulatedTime na freezeTime
                    accumulatedTime = TimeInterval(freezeTime)
                    isZoomed = false
                    // Czyscimy wybraną planetę – overlay zniknie
                    selectedPlanetBinding.wrappedValue = nil
                    print("isZoomed: false, accumulatedTime reset to freezeTime: \(freezeTime)")
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedPlanet: $selectedPlanet)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        // Tworzymy kotwicę dla układu planetarnego
        let anchorEntity = AnchorEntity(world: .zero)
        context.coordinator.planetaryAnchor = anchorEntity
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        
        // Dodajemy dodatkowe źródło światła – światło przypięte do kamery
        let cameraAnchor = AnchorEntity(.camera)
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        // Subskrypcja aktualizacji – animacja układu planetarnego
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            
            if context.coordinator.isZoomed {
                // W trybie zoom orbitalne pozycje pozostają zamrożone (używamy freezeTime),
                // natomiast obrót planet aktualizujemy zgodnie z bieżącym czasem.
//                print("tylko obrót")
                for planet in context.coordinator.planets {
                    planet.updateOrbit(elapsed: context.coordinator.freezeTime)
                    planet.updateRotation(elapsed: elapsed)
                }
            } else {
                for planet in context.coordinator.planets {
                    planet.update(elapsed: elapsed)
                }
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}


/*import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var selectedPlanet: Planet?
    
    class Coordinator: NSObject {
        var cancellable: Cancellable?
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        // Główna kotwica układu planetarnego
        var planetaryAnchor: AnchorEntity?
        // Flaga określająca, czy jesteśmy w trybie "zoom"
        var isZoomed = false
        // Zapamiętany oryginalny transform kotwicy, aby móc przywrócić stan
        var originalTransform: Transform?
        // Zapamiętany czas symulacji w momencie freeze (orbitalny ruch zamrożony)
        var freezeTime: Float = 0.0
        
        var selectedPlanetBinding: Binding<Planet?>
        
        init(selectedPlanet: Binding<Planet?>) {
            self.selectedPlanetBinding = selectedPlanet
        }
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            guard let arView = self.arView,
                  let planetaryAnchor = self.planetaryAnchor else { return }
            
            let tapLocation = recognizer.location(in: arView)
            print("Dotknięto ekranu")
            
            // Wykonujemy hit-test – korzystamy z pierwszego wyniku
            if let result = arView.hitTest(tapLocation, query: .nearest, mask: .all).first {
                // Używamy pozycji z wyniku hit-testu, aby uzyskać globalną pozycję trafionego obiektu
                let currentWorldPosition = result.position
                
                // Pobieramy bieżący transform kamery
                let cameraTransform = arView.cameraTransform
                let cameraMatrix = cameraTransform.matrix
                
                // Pozycja kamery
                let cameraPosition = SIMD3<Float>(
                    cameraMatrix.columns.3.x,
                    cameraMatrix.columns.3.y,
                    cameraMatrix.columns.3.z
                )
                // Wektor forward – ARKit ustawia kamerę, aby patrzyła w kierunku ujemnej osi Z
                let cameraForward = -SIMD3<Float>(
                    cameraMatrix.columns.2.x,
                    cameraMatrix.columns.2.y,
                    cameraMatrix.columns.2.z
                )
                
                // Docelowa pozycja: 0.5 m przed kamerą
                let desiredWorldPosition = cameraPosition + cameraForward * 0.5
                
                // Obliczamy przesunięcie (delta), które należy dodać do kotwicy,
                // aby trafiony obiekt znalazł się w desiredWorldPosition.
                let delta = desiredWorldPosition - currentWorldPosition
                
                // Sprawdzenie, czy obiekt jest przed kamerą
                let directionToObject = normalize(currentWorldPosition - cameraPosition)
                let dot = dot(directionToObject, cameraForward)
                if dot < 0 {
                    print("Obiekt znajduje się za kamerą – zoom nie zostanie wykonany.")
                    return
                }
                
                if !isZoomed {
                    // Przechowujemy bieżący czas symulacji jako freezeTime, aby orbitalne pozycje zostały zamrożone
                    freezeTime = Float(accumulatedTime)
                    
                    // Zapamiętujemy oryginalny transform kotwicy
                    originalTransform = planetaryAnchor.transform
                    
                    // Nie przerywamy subskrypcji – pozwalamy update'owi działać, ale z modyfikacją dla orbitalnego ruchu.
                    // Obliczamy nowy transform kotwicy przesuwając translację o delta.
                    var newTransform = planetaryAnchor.transform
                    newTransform.translation += delta
                    
                    // Animujemy przesunięcie kotwicy
                    planetaryAnchor.move(
                        to: newTransform,
                        relativeTo: planetaryAnchor.parent,
                        duration: 0.5,
                        timingFunction: .easeInOut
                    )
                    
                    isZoomed = true
                    print("isZoomed: true, freezeTime: \(freezeTime)")
                } else {
                    // Przywracamy oryginalny transform kotwicy
                    if let original = originalTransform {
                        planetaryAnchor.move(
                            to: original,
                            relativeTo: planetaryAnchor.parent,
                            duration: 0.5,
                            timingFunction: .easeInOut
                        )
                    }
                    // Aby symulacja wznowiła się płynnie, ustawiamy accumulatedTime tak, aby odpowiadał freezeTime.
                    accumulatedTime = TimeInterval(freezeTime)
                    
                    isZoomed = false
                    print("isZoomed: false, accumulatedTime reset to freezeTime: \(freezeTime)")
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedPlanet: $selectedPlanet)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        // Tworzymy kotwicę dla układu planetarnego
        let anchorEntity = AnchorEntity(world: .zero)
        context.coordinator.planetaryAnchor = anchorEntity
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        
        // Dodajemy dodatkowe źródło światła – światło przypięte do kamery
        let cameraAnchor = AnchorEntity(.camera)
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        // Subskrypcja aktualizacji – animacja układu planetarnego
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            
            if context.coordinator.isZoomed {
                // W trybie zoom orbitalne pozycje pozostają zamrożone (używamy freezeTime),
                // natomiast obrót planet aktualizujemy zgodnie z bieżącym czasem (elapsed).
                print("tylko obrót")
                for planet in context.coordinator.planets {
                    planet.updateOrbit(elapsed: context.coordinator.freezeTime)
                    planet.updateRotation(elapsed: elapsed)
                }
            } else {
                for planet in context.coordinator.planets {
                    planet.update(elapsed: elapsed)
                }
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}
*/

/*import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    class Coordinator: NSObject {
        var cancellable: Cancellable?
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        // Główna kotwica układu planetarnego
        var planetaryAnchor: AnchorEntity?
        // Flaga określająca, czy jesteśmy w trybie "zoom"
        var isZoomed = false
        // Zapamiętany oryginalny transform kotwicy, aby móc przywrócić stan
        var originalTransform: Transform?
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            guard let arView = self.arView,
                  let planetaryAnchor = self.planetaryAnchor else { return }
            
            let tapLocation = recognizer.location(in: arView)
            print("Dotknięto ekranu")
            
            // Wykonujemy hit-test – korzystamy z pierwszego wyniku
            if let result = arView.hitTest(tapLocation, query: .nearest, mask: .all).first {
                // Używamy worldTransform z wyniku hit-testu, aby uzyskać globalną pozycję trafionego obiektu
                let currentWorldPosition = result.position
                
                // Pobieramy bieżący transform kamery
                let cameraTransform = arView.cameraTransform
                let cameraMatrix = cameraTransform.matrix
                
                // Pozycja kamery
                let cameraPosition = SIMD3<Float>(
                    cameraMatrix.columns.3.x,
                    cameraMatrix.columns.3.y,
                    cameraMatrix.columns.3.z
                )
                // Wektor forward – ARKit ustawia kamerę, aby patrzyła w kierunku ujemnej osi Z
                let cameraForward = -SIMD3<Float>(
                    cameraMatrix.columns.2.x,
                    cameraMatrix.columns.2.y,
                    cameraMatrix.columns.2.z
                )
                
                // Wyznaczamy docelową pozycję: 0.5 m przed kamerą
                let desiredWorldPosition = cameraPosition + cameraForward * 0.5
                
                // Obliczamy przesunięcie (delta), które należy dodać do kotwicy, aby obiekt znalazł się w desiredWorldPosition
                let delta = desiredWorldPosition - currentWorldPosition
                
                // Dodatkowo – zabezpieczenie: upewnij się, że obiekt jest faktycznie przed kamerą
                let directionToObject = normalize(currentWorldPosition - cameraPosition)
                let dot = dot(directionToObject, cameraForward)
                // Jeśli dot < 0, obiekt jest za kamerą – wtedy nie wykonujemy zoomu
                if dot < 0 {
                    print("Obiekt znajduje się za kamerą – zoom nie zostanie wykonany.")
                    return
                }
                
                if !isZoomed {
                    // Zapamiętujemy oryginalny transform kotwicy
                    originalTransform = planetaryAnchor.transform
                    
                    // Nie anulujemy subskrypcji – pozostawiamy ją aktywną
                    // Obliczamy offset, przesuwamy kotwicę, animujemy ją...
                    var newTransform = planetaryAnchor.transform
                    newTransform.translation += delta
                    
                    planetaryAnchor.move(
                        to: newTransform,
                        relativeTo: planetaryAnchor.parent,
                        duration: 0.5,
                        timingFunction: .easeInOut
                    )
                    
                    isZoomed = true
                } else {
                    // Przywracamy oryginalny transform
                    if let original = originalTransform {
                        planetaryAnchor.move(
                            to: original,
                            relativeTo: planetaryAnchor.parent,
                            duration: 0.5,
                            timingFunction: .easeInOut
                        )
                    }
                    
                    isZoomed = false
                }
            }
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        // Tworzymy kotwicę dla układu planetarnego
        let anchorEntity = AnchorEntity(world: .zero)
        context.coordinator.planetaryAnchor = anchorEntity
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        
        // Dodajemy dodatkowe źródło światła – światło przypięte do kamery
        let cameraAnchor = AnchorEntity(.camera)
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        // Obracamy światło o 45° wokół osi X
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        // Subskrypcja aktualizacji – animacja układu planetarnego
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            if context.coordinator.isZoomed {
                // Gdy układ jest przybliżony, aktualizujemy tylko obrót planet
                print("tylko obrót")
                for planet in context.coordinator.planets {
                    planet.updateRotation(elapsed: elapsed)
                }
            } else {
                // Pełna animacja (orbita + obrót)
                for planet in context.coordinator.planets {
                    planet.update(elapsed: elapsed)
                }
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}

*/
    
    
/*    class Coordinator: NSObject { //dodanie zoom na planetę i stop układu
        var cancellable: Cancellable?
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        // Dodajemy referencję do głównej kotwicy układu planetarnego
        var planetaryAnchor: AnchorEntity?
        // Flaga, czy jesteśmy w trybie zoom
        var isZoomed = false
        // Zapamiętujemy oryginalny transform kotwicy, aby móc przywrócić stan
        var originalTransform: Transform?
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            guard let arView = self.arView,
                  let planetaryAnchor = self.planetaryAnchor else { return }
            print("Dotknięto ekranu")
            let tapLocation = recognizer.location(in: arView)
            
            
            // Wykonujemy hit-test, aby sprawdzić, czy dotknięto obiekt
            if let result = arView.hitTest(tapLocation, query: .nearest, mask: .all).first,
               let tappedEntity = result.entity as? ModelEntity {
                print("Dotknięto obiekt: \(tappedEntity.name)")
                
                // Pobieramy bieżący transform kamery
                let cameraTransform = arView.cameraTransform
                
                if !isZoomed {
                    // Zapamiętujemy oryginalny transform kotwicy
                    originalTransform = planetaryAnchor.transform
                    
                    // Zatrzymujemy animację układu planetarnego (przerywamy subskrypcję)
                    cancellable?.cancel()
                    
                    // Obliczamy pozycję, w której chcemy umieścić dotknięty obiekt
                    // Chcemy, aby w przestrzeni kamery znalazł się on na pozycji (0, 0, -0.5)
                    // Najpierw przeliczamy tę pozycję do przestrzeni świata:
                    let desiredCameraSpacePosition = SIMD3<Float>(0, 0, -0.5)
                    // Używamy macierzy transform kamery, aby uzyskać pozycję w świecie:
                    let cameraMatrix = cameraTransform.matrix
                    // Uwaga: cameraMatrix.columns.3 zawiera translację, a górny-lewy 3x3 to rotacja.
                    // Wyodrębniamy poszczególne kolumny macierzy jako wektory
                    let col0 = SIMD3<Float>(cameraMatrix.columns.0.x, cameraMatrix.columns.0.y, cameraMatrix.columns.0.z)
                    let col1 = SIMD3<Float>(cameraMatrix.columns.1.x, cameraMatrix.columns.1.y, cameraMatrix.columns.1.z)
                    let col2 = SIMD3<Float>(cameraMatrix.columns.2.x, cameraMatrix.columns.2.y, cameraMatrix.columns.2.z)
                    // Jeśli nie masz właściwości .xyz, pobieramy translację z kolumny 3 ręcznie
                    let translation = SIMD3<Float>(cameraMatrix.columns.3.x, cameraMatrix.columns.3.y, cameraMatrix.columns.3.z)

                    // Obliczamy offset w przestrzeni kamery
                    let offset = col0 * desiredCameraSpacePosition.x +
                                 col1 * desiredCameraSpacePosition.y +
                                 col2 * desiredCameraSpacePosition.z

                    // Wyznaczamy docelową pozycję w przestrzeni świata
                    let desiredWorldPosition = translation + offset
                    
                    // Pobieramy bieżącą pozycję dotkniętego obiektu (w przestrzeni świata)
                    let currentWorldPosition = tappedEntity.convert(position: tappedEntity.position, to: nil)
                    
                    // Obliczamy offset, o który musimy przesunąć cały układ, aby dotknięty obiekt znalazł się w desiredWorldPosition
                    let offsetSolarSystem = desiredWorldPosition - currentWorldPosition
                    
                    // Nowy transform kotwicy – przesuwamy jej translację o offset
                    var newTransform = planetaryAnchor.transform
                    newTransform.translation += offsetSolarSystem
                    
                    // Animujemy zmianę transformacji kotwicy
                    planetaryAnchor.move(
                        to: newTransform,
                        relativeTo: planetaryAnchor.parent,
                        duration: 0.5,
                        timingFunction: .easeInOut
                    )
                    
                    isZoomed = true
                } else {
                    // Jeśli już jesteśmy w trybie zoom, przywracamy oryginalny transform
                    if let original = originalTransform {
                        planetaryAnchor.move(
                            to: original,
                            relativeTo: planetaryAnchor.parent,
                            duration: 0.5,
                            timingFunction: .easeInOut
                        )
                    }
                    
                    // Ponownie subskrybujemy aktualizacje (musisz ponownie ustawić subskrypcję)
                    self.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
                        self.accumulatedTime += event.deltaTime
                        let elapsed = Float(self.accumulatedTime)
                        for planet in self.planets {
                            planet.update(elapsed: elapsed)
                        }
                    }
                    
                    isZoomed = false
                }
            }
        }
    }
    
/*    class Coordinator: NSObject {
        var cancellable: Cancellable?
        // Lista planet – pobieramy ją z pliku SolarSystemPlanets.swift
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        @objc func handleTap(recognizer: UITapGestureRecognizer) {
            guard let arView = self.arView else { return }
            let tapLocation = recognizer.location(in: arView)
            print("Dotknięto ekranu")
            // Wykonujemy hit-test, aby sprawdzić, czy dotknięto jakiegoś obiektu
            if let result = arView.hitTest(tapLocation, query: .nearest, mask: .all).first,
               let modelEntity = result.entity as? ModelEntity {
                print("Dotknięto obiekt: ")
                
                // Animacja skalowania:
                // Pobieramy aktualny transform obiektu
                var newTransform = modelEntity.transform
                // Ustawiamy nową skalę – tutaj zwiększamy skalę o 50%
                newTransform.scale = modelEntity.transform.scale * 1.5
                
                // Animujemy przejście do nowego transformu w ciągu 0.5 sekundy
                modelEntity.move(to: newTransform, relativeTo: modelEntity.parent, duration: 0.5, timingFunction: .easeInOut)
            }
        }
    }
 */
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
            arView.addGestureRecognizer(tapGesture)

        
        // Kotwica na planety – wszystkie planety umieszczamy względem świata
        let anchorEntity = AnchorEntity(world: .zero)
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        //Dodajemy księżyc
        
        // Znajdujemy Ziemię w liście planet (przyjmujemy, że jej nazwa to "Earth")
        if let earthIndex = context.coordinator.planets.firstIndex(where: { $0.name == "Earth" }),
           let earthEntity = context.coordinator.planets[earthIndex].entity {
            // Tworzymy księżyc – korzystamy z naszej struktury Planet, ale ustawiamy orbitCenter = (0,0,0)
            let moonOrbitRadius: Float = 0.2   // odległość księżyca od Ziemi w metrach
            let moonOrbitPeriod: Float = 0.5    // przykładowo 5 sekund na pełny obrót wokół Ziemi
            let moonOrbitSpeed: Float = (2 * Float.pi) / moonOrbitPeriod
            let moonSelfRotationSpeed: Float = (2 * Float.pi)*5  // np. taki sam jak orbitSpeed księżyca
            
            let moon = Planet(
                name: "Moon",
                textureName: "moon",         // upewnij się, że masz teksturę "moon" w zasobach
                radius: 0.03,                // przykładowy promień księżyca
                orbitRadius: moonOrbitRadius,
                orbitCenter: SIMD3<Float>(0, 0, 0),  // orbituje względem Ziemi
                orbitSpeed: moonOrbitSpeed,
                selfRotationSpeed: moonSelfRotationSpeed
            )
            
            if let moonEntity = moon.entity {
                // Ustawiamy początkową pozycję księżyca względem Ziemi (np. na prawo)
                moonEntity.position = SIMD3<Float>(moonOrbitRadius, 0, 0)
                // Dodajemy księżyc jako dziecko Ziemi – wtedy księżyc będzie "podążał" za ruchem Ziemi
                earthEntity.addChild(moonEntity)
                
                // Opcjonalnie: jeśli chcesz aktualizować księżyc, możesz przechowywać go w osobnej liście,
                // np. context.coordinator.moons.append(moon)
                // i w updateUIView wywoływać moon.update(elapsed:) osobno.
            }
        }

        
        
        // Dodajemy dodatkowe źródło światła – światło przypięte do kamery
        let cameraAnchor = AnchorEntity(.camera)
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        // Obracamy światło o 45° wokół osi X
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        // Subskrypcja zdarzeń aktualizacji – animacja planet
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            // Aktualizujemy każdą planetę
            for planet in context.coordinator.planets {
                planet.update(elapsed: elapsed)
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}
*/

/*import SwiftUI
import RealityKit
import ARKit
import Combine

struct ARViewContainer: UIViewRepresentable {
    
    class Coordinator: NSObject {
        var cancellable: Cancellable?
        var planets: [Planet] = []
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        
        // Przykładowe planety – możesz dodać ich więcej lub zmienić parametry
        let earth = Planet(name: "Earth",
                           textureName: "earth",
                           radius: 0.1,
                           orbitRadius: 0.8,
                           orbitCenter: SIMD3<Float>(0, 0, -1),
                           orbitSpeed: 0.628,      // pełny obrót orbity w ~10 sekund
                           selfRotationSpeed: .pi)  // pełny obrót wokół własnej osi w 2 sekundy
        let mars = Planet(name: "Mars",
                          textureName: "mars",
                          radius: 0.07,
                          orbitRadius: 1.2,
                          orbitCenter: SIMD3<Float>(0, 0, -1),
                          orbitSpeed: 0.5,
                          selfRotationSpeed: 0.8)
        coordinator.planets.append(earth)
        coordinator.planets.append(mars)
        
        return coordinator
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Utworzenie kotwicy na planety – tutaj umieszczamy je względem świata (AnchorEntity w punkcie (0,0,0))
        let anchorEntity = AnchorEntity(world: .zero)
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        
        // Dodanie dodatkowego źródła światła – światło umieszczone w kotwicy kamery
        let cameraAnchor = AnchorEntity(.camera)
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        // Obrót światła o 45° wokół osi X
        lightEntity.transform.rotation = simd_quatf(angle: .pi/4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        // Subskrypcja zdarzeń aktualizacji sceny – animacja planet
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            for planet in context.coordinator.planets {
                planet.update(elapsed: elapsed)
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}
*/

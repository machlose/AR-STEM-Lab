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
    @Binding var selectedPlanet: PlanetInformation?
    @Binding var overlayToggle: Bool

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
        var selectedPlanetBinding: Binding<PlanetInformation?>
        var overlayToggle: Binding<Bool>

        init(selectedPlanet: Binding<PlanetInformation?>, overlayToggle: Binding<Bool>) {
            self.selectedPlanetBinding = selectedPlanet
            self.overlayToggle = overlayToggle
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
                        selectedPlanetBinding.wrappedValue = tappedPlanet.planetInformation
                        overlayToggle.wrappedValue = true
                    }
                    
                    planetaryAnchor.stopAllAnimations()
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
                    overlayToggle.wrappedValue = false
                    print("isZoomed: false, accumulatedTime reset to freezeTime: \(freezeTime)")
                }
            }
        }
    }
    
    func moveCamera(arView: ARView, position: SIMD3<Float>, rotation: SIMD3<Float>, duration: TimeInterval){
        guard let planetaryAnchor = arView.scene.findEntity(named: "planetaryAnchor") as? AnchorEntity else {
            print("nie znaleziono planetaryAnchor")
            return
        }
        
        var cameraTransform = Transform()
        cameraTransform.translation = -position
        
        let quatX = simd_quatf(angle: -rotation.x, axis: [1, 0, 0])
        let quatY = simd_quatf(angle: -rotation.y, axis: [0, 1, 0])
        let quatZ = simd_quatf(angle: -rotation.z, axis: [0, 0, 1])
        cameraTransform.rotation = quatX * quatY * quatZ
        
        planetaryAnchor.move(to: cameraTransform, relativeTo: planetaryAnchor.parent, duration: duration, timingFunction: .easeInOut)
//        print(cameraTransform)
    }
    
    func moveCameraAlongPath(arView: ARView, path: [(position: SIMD3<Float>, rotation: SIMD3<Float>, duration: TimeInterval)]){
        if path.isEmpty {
            return
        }
        
        let firstPoint = path[0]
        let remainingPath = Array(path.dropFirst())
        
        moveCamera(arView: arView, position: firstPoint.position, rotation: firstPoint.rotation, duration: firstPoint.duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + firstPoint.duration){
            moveCameraAlongPath(arView: arView, path: remainingPath)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedPlanet: $selectedPlanet, overlayToggle: $overlayToggle)
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
        anchorEntity.name = "planetaryAnchor"
        context.coordinator.planetaryAnchor = anchorEntity
        for planet in context.coordinator.planets {
            if let planetEntity = planet.entity {
                anchorEntity.addChild(planetEntity)
            }
        }
        arView.scene.addAnchor(anchorEntity)
        
        // Dodajemy dodatkowe źródło światła – światło przypięte do kamery
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.name = "cameraAnchor"
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        let cameraPath: [(position: SIMD3<Float>, rotation: SIMD3<Float>, duration: TimeInterval)] = [
            (position: SIMD3<Float>(1,0,0), rotation: SIMD3<Float>(-1,0,0), duration: 1),
            (position: SIMD3<Float>(-1,0,0), rotation: SIMD3<Float>(1,0,0), duration: 1),
            (position: SIMD3<Float>(0,0,0), rotation: SIMD3<Float>(0,0,0), duration: 1),
        ]
//        moveCameraAlongPath(arView: arView, path: cameraPath)
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
                    planet.updateRotation(delta: Float(event.deltaTime))
                }
            } else {
                for planet in context.coordinator.planets {
                    planet.update(elapsed: elapsed,delta: Float(event.deltaTime))
                }
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}



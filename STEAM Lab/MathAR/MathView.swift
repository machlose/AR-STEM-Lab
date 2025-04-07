//
//  MathView.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 07/04/2025.
//

import SwiftUI

struct MathView: View {
    @Binding var reset: Bool
    @State private var selectedPlanetInformation: PlanetInformation? = nil
    @State private var overlayShow: Bool = false
    @State private var speed: Double = 1

    var body: some View {
        ZStack {
            ARViewContainer(selectedPlanet: $selectedPlanetInformation, overlayToggle: $overlayShow)
                .edgesIgnoringSafeArea(.all)
            VStack{
                    Button{
                        reset = false
                    }
                    label:{
                        HStack{
                            Image(systemName: "chevron.backward")
                            Text("Back")
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        .padding()
                    }
                PickPlanetView(show: $overlayShow)
                PlanetSpeedSlider(show: $overlayShow, value: $speed)
                Spacer()
                PlanetOverlayView(planet: $selectedPlanetInformation, show: $overlayShow)
            }
        }
        .onChange(of: overlayShow){
            if !overlayShow{
                Planet.changeRotationModifier(1)
                speed = 1
            }
        }
        .onChange(of: speed){
            Planet.changeRotationModifier(speed)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
////        @StateObject var appState = AppState()
////        SolarView()
////            .environmentObject(appState)
//    }
//}


/*
import SwiftUI
import RealityKit
import ARKit
import Combine

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    class Coordinator: NSObject {
        var sphereEntity: ModelEntity?
        var accumulatedTime: TimeInterval = 0
        var cancellable: Cancellable?
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Tworzenie zielonej kuli (promień 0.1 m)
        // Ładujemy zasób tekstury z katalogu zasobów projektu
        guard let textureResource = try? TextureResource.load(named: "earth") else {
            fatalError("Nie udało się załadować tekstury")
        }

        // Tworzymy materiał – w tym przypadku używamy PhysicallyBasedMaterial, który reaguje na oświetlenie.
        // Jeśli nie chcesz, aby materiał reagował na oświetlenie, możesz użyć UnlitMaterial.
        var material = PhysicallyBasedMaterial()
        // Ustawiamy bazowy kolor materiału, wykorzystując załadowaną teksturę oraz biały tint (brak zmiany koloru)
        material.baseColor = .init(texture: .init(textureResource))

        // Tworzymy siatkę kuli o zadanym promieniu
        let sphereMesh = MeshResource.generateSphere(radius: 0.1)
        // Łączymy siatkę z utworzonym materiałem
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])

        /*let sphereMesh = MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])*/
        // Początkowa pozycja – będzie zmieniana przez animację
        sphereEntity.position = SIMD3<Float>(0, 0, -1)
        
        // Utworzenie kotwicy i dodanie kuli do niej
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.addChild(sphereEntity)
        arView.scene.addAnchor(anchorEntity)
        
        // Przechowujemy referencję do kuli w koordynatorze
        context.coordinator.sphereEntity = sphereEntity
        
        // Subskrypcja zdarzeń aktualizacji sceny
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            guard let sphere = context.coordinator.sphereEntity else { return }
            
            // Aktualizacja skumulowanego czasu przy użyciu event.deltaTime
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            
            // Definicja ruchu: kąt rośnie liniowo, co daje obrót z prędkością angularSpeed
            // Przykładowo: pełen obrót (2π) w 10 sekund => angularSpeed = 2π/10 ≈ 0.628 rad/s
            let angularSpeed: Float = 0.628
            let angle = elapsed * angularSpeed
            
            // Środek okręgu (pozycja 1 m przed urządzeniem)
            let center = SIMD3<Float>(0, 0, -1)
            let radius: Float = 0.8
            
            // Nowe położenie kuli na okręgu w płaszczyźnie xz
            let newX = center.x + radius * cos(angle)
            let newZ = center.z + radius * sin(angle)
            sphere.position = SIMD3<Float>(newX, center.y, newZ)
            
            // Rotacja kuli wokół własnej osi (pełen obrót w 2 sekundy)
            let spinSpeed: Float = .pi  // 2π radianów / 2 sekundy = π rad/s
            let spinAngle = elapsed * spinSpeed
            sphere.orientation = simd_quatf(angle: spinAngle, axis: SIMD3<Float>(0, 1, 0))
            
            // Utworzenie kotwicy kamery (wymaga iOS 15+/RealityKit 2)
            let cameraAnchor = AnchorEntity(.camera)

            // Utworzenie światła – tutaj przykładowo używamy światła kierunkowego
            let lightEntity = DirectionalLight()
            lightEntity.light.intensity = 1000  // Dostosuj intensywność do potrzeb
            lightEntity.light.color = .white

            // Opcjonalnie możesz ustawić transformację światła względem kamery
            // Przykładowo obracamy światło o 45° wokół osi X:
            lightEntity.transform.rotation = simd_quatf(angle: .pi/4, axis: SIMD3<Float>(1, 0, 0))

            // Dodanie światła jako dziecka kotwicy kamery
            cameraAnchor.addChild(lightEntity)

            // Dodaj kotwicę kamery do sceny AR
            arView.scene.addAnchor(cameraAnchor)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli są potrzebne
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/

/*
import SwiftUI
import RealityKit
import ARKit

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Tworzenie zielonej kuli (promień 0.1 m, czyli kula o średnicy 0.2 m)
        let sphereMesh = MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: .green, isMetallic: false)
        let sphereEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        
        // Ustawienie pozycji kuli 1 metr przed urządzeniem (w układzie kamery, z przodu to -Z)
        sphereEntity.position = SIMD3<Float>(0, 0, -1)
        
        // Utworzenie kotwicy i dodanie kuli do niej
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.addChild(sphereEntity)
        
        arView.scene.addAnchor(anchorEntity)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Aktualizacje widoku, jeśli potrzebne
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
*/

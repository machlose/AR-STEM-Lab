//
//  ARViewContainer.swift
//  STEAM Lab
//
//  Created by Marcin Świętkowski on 07/04/2025.
//


import SwiftUI
import RealityKit
import ARKit
import Combine

struct MathARViewContainer: UIViewRepresentable {

    class Coordinator: NSObject {
        var cancellable: Cancellable?
        var arView: ARView?
        var anchor: AnchorEntity?

        @objc func handleTap(recognizer: UITapGestureRecognizer) {
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        let textureName = "sun"
        guard let textureResource = try? TextureResource.load(named: textureName) else {
            print("Nie udało się załadować tekstury \(textureName)")
            exit(0)
        }

        let sphereMesh = MeshResource.generateCone(height: 20, radius: 10)
        
        var material = PhysicallyBasedMaterial()

        let cubeEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        cubeEntity.generateCollisionShapes(recursive: true)
        
        cubeEntity.position = SIMD3(x: 0.0, y: 0.0, z: -100.0)
        cubeEntity.transform.rotation = simd_quatf(angle: .pi/4, axis: SIMD3<Float>(.pi/2,.pi/2,0).Normalized());
        let cone2 = cubeEntity.clone(recursive: true)
        
        cone2.scale *= Float(1.02)
        var material2 = PhysicallyBasedMaterial()
        material2.emissiveIntensity = 10
        material2.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(color: .white)
        material2.faceCulling = .front
        cone2.model?.materials[0] = material2
        
        let worldAnchor = AnchorEntity(world: .zero)
        
        worldAnchor.addChild(cubeEntity)
        worldAnchor.addChild(cone2)
        context.coordinator.anchor = worldAnchor
        
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.name = "cameraAnchor"
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        
        arView.scene.addAnchor(worldAnchor)
        
        
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        @StateObject var appState = AppState()
        MathView()
            .environmentObject(appState)
    }
}


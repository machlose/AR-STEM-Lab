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

        let sphereMesh = MeshResource.generateBox(size: 10)
        
        var material = PhysicallyBasedMaterial()
//        material.baseColor = PhysicallyBasedMaterial.BaseColor.init(tint:.red)
        material.baseColor = .init(tint: .red, texture: .init(textureResource))

        let cubeEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        cubeEntity.generateCollisionShapes(recursive: true)
        
        let worldAnchor = AnchorEntity(world: .zero)
        
        worldAnchor.addChild(cubeEntity)
        context.coordinator.anchor = worldAnchor
        
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.name = "cameraAnchor"
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        
        arView.scene.addAnchor(worldAnchor)
        
//        worldAnchor.addChild()
        
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

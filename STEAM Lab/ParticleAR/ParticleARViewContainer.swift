//
//  ParticleARViewContainer.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct ParticleARViewContainer: UIViewRepresentable {
    @Binding var currentAtom: Int?
    @EnvironmentObject var appState: AppState
    class AtomCoordinator: NSObject {
        var curentAtom: Int?
        var cancellable: Cancellable?
        var Particles: [Particle]? //= Atoms[1].particles
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?

        var planetaryAnchor: AnchorEntity?
        var isZoomed = false
        var originalTransform: Transform?
        var freezeTime: Float = 0.0
        
        var overlayToggle: Bool = true

        init(currentAtom: Binding<Int?>) {
            let value: Int? = currentAtom.wrappedValue ?? 2
            curentAtom = value
            if(curentAtom != nil){
                Particles = generateAtomicCenter(Protons: Atoms[curentAtom!].protons, Neutrons: Atoms[curentAtom!].neutrons) + generateElectrons(shells: Atoms[curentAtom!].shells)
            }
        }
        func changeAtom() {
            for i in 0..<Particles!.count{
                Particles?[0].entity?.removeFromParent()
                Particles?.remove(at: 0)
            }
            if(curentAtom != nil){
                Particles = generateAtomicCenter(Protons: Atoms[curentAtom!].protons, Neutrons: Atoms[curentAtom!].neutrons) + generateElectrons(shells: Atoms[curentAtom!].shells)
            }
            for planet in Particles! {
                if let planetEntity = planet.entity {
                    planetaryAnchor!.addChild(planetEntity)
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
    }
    
    func moveCameraAlongPath(arView: ARView, path: [(position: SIMD3<Float>, rotation: SIMD3<Float>, duration: TimeInterval)], forever: Bool = false){
        if path.isEmpty {
            return
        }
        
        let firstPoint = path[0]
        var remainingPath = Array(path.dropFirst())
        remainingPath.append(firstPoint)
        
        moveCamera(arView: arView, position: firstPoint.position, rotation: firstPoint.rotation, duration: firstPoint.duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + firstPoint.duration){
            self.moveCameraAlongPath(arView: arView, path: remainingPath)
        }
    }
    
    func makeCoordinator() -> AtomCoordinator {
        AtomCoordinator(currentAtom: $currentAtom)
//        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        // Konfiguracja AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        
        let anchorEntity = AnchorEntity(world: .zero)
        anchorEntity.name = "planetaryAnchor"
        context.coordinator.planetaryAnchor = anchorEntity
        for planet in context.coordinator.Particles! {
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
            (position: SIMD3<Float>(0,0,0.5), rotation: SIMD3<Float>(5,0,0).Normalized(), duration: 0),
        ]
        moveCameraAlongPath(arView: arView, path: cameraPath)
        context.coordinator.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            context.coordinator.accumulatedTime += event.deltaTime
            let elapsed = Float(context.coordinator.accumulatedTime)
            
            if context.coordinator.isZoomed {
                for planet in context.coordinator.Particles! {
                    planet.updateOrbit(elapsed: context.coordinator.freezeTime)
                }
            } else {
                for planet in context.coordinator.Particles! {
                    planet.update(elapsed: elapsed,delta: Float(event.deltaTime))
                }
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if(currentAtom != context.coordinator.curentAtom){
            context.coordinator.curentAtom = currentAtom
            context.coordinator.changeAtom()
        }
        
    }
}


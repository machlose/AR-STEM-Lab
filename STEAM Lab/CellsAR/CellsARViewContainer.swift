//
//  CellsARViewContainer.swift
//  STEAM Lab
//
//  Created by uczen on 21/05/2025.
//

import SwiftUI
import RealityKit
import ARKit
import Combine

struct CellsARViewContainer: UIViewRepresentable {
    class CellsCoordinator: NSObject {
        var cancellable: Cancellable?

        var accumulatedTime: TimeInterval = 0
        var arView: ARView?
        
        var planetaryAnchor: AnchorEntity?
        var isZoomed = false
        var originalTransform: Transform?
        var freezeTime: Float = 0.0
        
        var overlayToggle: Bool = true

        init(currentAtom: Int) {
            
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
        print(cameraTransform)
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
    
    func makeCoordinator() -> CellsCoordinator {
        CellsCoordinator(currentAtom: 0)
//        Coordinator()
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        context.coordinator.arView = arView
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        
        let anchorEntity = AnchorEntity(world: .zero)
        context.coordinator.planetaryAnchor = anchorEntity
        
        
        
        if let cellModel = try? Entity.loadModel(contentsOf: URL(fileURLWithPath: "Animal_cell_2.usdz")){
            print(cellModel.children)
            anchorEntity.addChild(cellModel)//nie działa
        } else {
            print("failed to load model: Animal_cell_2")
        }
        if let planetEntity = Electron.entity {
            anchorEntity.addChild(planetEntity)
        }
        arView.scene.addAnchor(anchorEntity)
        
        let cameraAnchor = AnchorEntity(.camera)
        cameraAnchor.name = "cameraAnchor"
        let lightEntity = DirectionalLight()
        lightEntity.light.intensity = 1000
        lightEntity.light.color = .white
        lightEntity.transform.rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(1, 0, 0))
        cameraAnchor.addChild(lightEntity)
        arView.scene.addAnchor(cameraAnchor)
        
        let cameraPath: [(position: SIMD3<Float>, rotation: SIMD3<Float>, duration: TimeInterval)] = [
            (position: SIMD3<Float>(0,0,1), rotation: SIMD3<Float>(0,0,0).Normalized(), duration: 0),
        ]
        moveCameraAlongPath(arView: arView, path: cameraPath)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //
    }
}

struct Content_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var appState = AppState()
        @State var bomba: Experiments? =  nil
        CellsView(reset: $bomba)
            .environmentObject(appState)
    }
}


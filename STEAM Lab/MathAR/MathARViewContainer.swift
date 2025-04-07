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
        var planets: [Planet] = solarSystemPlanets
        var accumulatedTime: TimeInterval = 0
        var arView: ARView?

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
        
        // Dodajemy gest dotyku
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(recognizer:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

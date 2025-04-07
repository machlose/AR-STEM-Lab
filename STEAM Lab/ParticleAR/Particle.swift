//
//  Particle.swift
//  STEAM Lab
//
//  Created by Adrian Nowacki on 07/04/2025.
//

import RealityKit
import SwiftUI
import Foundation

struct Particle {
    var name: String
    var textureName: String
    var radius: Float
    var orbitRadius: Float = 0
    var orbitCenter: SIMD3<Float> = SIMD3<Float>(0, 0, -1) // Wszystkie orbity umieszczone względem tego samego środka
    var orbitSpeed: Float = 0          // Prędkość orbitalna w radianach na sekundę
    public static var rotationSpeedModifier: Double = 1
    
    // Encja reprezentująca planetę w scenie AR
    var entity: ModelEntity?
    
    init(name: String,
         textureName: String,
         radius: Float,
         orbitRadius: Float = 0,
         orbitCenter: SIMD3<Float> = SIMD3<Float>(0, 0, -1),
         orbitSpeed: Float = 0
    ) {
        self.name = name
        self.textureName = textureName
        self.radius = radius
        self.orbitRadius = orbitRadius
        self.orbitCenter = orbitCenter
        self.orbitSpeed = orbitSpeed
        
        self.entity = createEntity()
    }
    
    private func createEntity() -> ModelEntity? {
        // Ładujemy teksturę planety z zasobów projektu
        guard let textureResource = try? TextureResource.load(named: textureName) else {
            print("Nie udało się załadować tekstury \(textureName)")
            return nil
        }
        
        // Generujemy siatkę kuli o zadanym promieniu
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        
        // Dla Słońca chcemy uzyskać efekt świecenia, dlatego ustawiamy dodatkową emisję.
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(texture: .init(textureResource))
        if name == "Sun" {
            // Ustawiamy emisję – jasny żółty efekt, który sprawi, że Słońce będzie wyglądać, jakby świeciło
            material.emissiveColor = .init(color: .yellow, texture: .init(textureResource))
            //.init(tint: .yellow, texture: nil)
        }
        
        let planetEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        planetEntity.name = name
        planetEntity.generateCollisionShapes(recursive: true)
        return planetEntity
    }
    
    // Funkcja aktualizująca pozycję i obrót planety na podstawie upływającego czasu
    func updateOrbit(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        let angle = elapsed * orbitSpeed
        let newX = orbitCenter.x + orbitRadius * cos(angle)
        let newZ = orbitCenter.z + orbitRadius * sin(angle)
        planetEntity.position = SIMD3<Float>(newX, orbitCenter.y, newZ)
    }
    
    public func update(elapsed: Float,delta: Float) {
        updateOrbit(elapsed: elapsed)
    }
}

//
//  Planet.swift
//  SphereAR
//
//  Created by Rafał Michałowski on 20/03/2025.
//

import RealityKit
import SwiftUI
import Foundation

struct Planet {
    var name: String
    var textureName: String
    var radius: Float
    var orbitRadius: Float
    var orbitCenter: SIMD3<Float> = SIMD3<Float>(0, 0, -1) // Wszystkie orbity umieszczone względem tego samego środka
    var orbitSpeed: Float         // Prędkość orbitalna w radianach na sekundę
    var selfRotationSpeed: Float  // Prędkość obrotu wokół własnej osi w radianach na sekundę
    @State var planetInformation: PlanetInformation
    public static var rotationSpeedModifier: Double = 1
    var lastElapsed: Float

    // Encja reprezentująca planetę w scenie AR
    var entity: ModelEntity?
    
    init(name: String,
         textureName: String,
         radius: Float,
         orbitRadius: Float,
         orbitCenter: SIMD3<Float> = SIMD3<Float>(0, 0, -1),
         orbitSpeed: Float,
         selfRotationSpeed: Float,
         planetInformation: PlanetInformation,
         lastElapsed: Float = 0
    ) {
        self.name = name
        self.textureName = textureName
        self.radius = radius
        self.orbitRadius = orbitRadius
        self.orbitCenter = orbitCenter
        self.orbitSpeed = orbitSpeed
        self.selfRotationSpeed = selfRotationSpeed
        self.planetInformation = planetInformation
        self.lastElapsed = lastElapsed

        self.entity = createEntity()
        print(lastElapsed)
    }
    public static func changeRotationModifier(_ speed: Double){
        self.rotationSpeedModifier = speed
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
    
    /*private func createEntity() -> ModelEntity? {
        // Ładujemy teksturę planety z zasobów projektu
        guard let textureResource = try? TextureResource.load(named: textureName) else {
            print("Nie udało się załadować tekstury \(textureName)")
            return nil
        }
        
        // Tworzymy materiał oparty na PhysicallyBasedMaterial
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(texture: .init(textureResource))
        
        // Generujemy siatkę kuli o zadanym promieniu
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let planetEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        
        // Ustawiamy początkową pozycję – na orbicie, zaczynając od punktu po prawej stronie środka orbity
        planetEntity.position = orbitCenter + SIMD3<Float>(orbitRadius, 0, 0)
        
        return planetEntity
    }*/
    
    // Funkcja aktualizująca pozycję i obrót planety na podstawie upływającego czasu
    func updateOrbit(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        let angle = elapsed * orbitSpeed
        let newX = orbitCenter.x + orbitRadius * cos(angle)
        let newZ = orbitCenter.z + orbitRadius * sin(angle)
        planetEntity.position = SIMD3<Float>(newX, orbitCenter.y, newZ)
    }

    public func updateRotation(delta: Float) {
        let speedModifier = Float(Planet.rotationSpeedModifier)
        guard let planetEntity = self.entity else { return }
        
        var rotationAngle = planetEntity.orientation.angle + (delta * selfRotationSpeed * speedModifier)
        if rotationAngle > (.pi*2){
            rotationAngle -= (.pi*2)
        }
                             
        print(rotationAngle,delta,selfRotationSpeed,speedModifier)

        planetEntity.orientation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
    public func setRotation(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        var rotationAngle = elapsed * selfRotationSpeed

        planetEntity.orientation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }

    /// Aktualizuje pełną animację: orbita i obrót.
    public func update(elapsed: Float,delta: Float) {
        updateOrbit(elapsed: elapsed)
        updateRotation(delta: delta)
    }
    
    /*func update(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        
        // Obliczamy kąt dla orbity
        let angle = elapsed * orbitSpeed
        // Nowa pozycja na orbicie w płaszczyźnie xz
        let newX = orbitCenter.x + orbitRadius * cos(angle)
        let newZ = orbitCenter.z + orbitRadius * sin(angle)
        planetEntity.position = SIMD3<Float>(newX, orbitCenter.y, newZ)
        
        // Obrót planety wokół własnej osi (zakładamy obrót wokół osi Y)
        let rotationAngle = elapsed * selfRotationSpeed
        planetEntity.orientation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
    
    func updateRotation(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        
        let rotationAngle = elapsed * selfRotationSpeed
        planetEntity.orientation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }*/
}


/*import RealityKit
import Foundation

struct Planet {
    var name: String
    var textureName: String
    var radius: Float
    var orbitRadius: Float
    var orbitCenter: SIMD3<Float>
    var orbitSpeed: Float         // prędkość obrotu orbity (w radianach na sekundę)
    var selfRotationSpeed: Float  // prędkość obrotu wokół własnej osi (w radianach na sekundę)
    
    // Encja reprezentująca planetę w scenie AR
    var entity: ModelEntity?
    
    init(name: String,
         textureName: String,
         radius: Float,
         orbitRadius: Float,
         orbitCenter: SIMD3<Float>,
         orbitSpeed: Float,
         selfRotationSpeed: Float) {
        self.name = name
        self.textureName = textureName
        self.radius = radius
        self.orbitRadius = orbitRadius
        self.orbitCenter = orbitCenter
        self.orbitSpeed = orbitSpeed
        self.selfRotationSpeed = selfRotationSpeed
        self.entity = createEntity()
    }
    
    private func createEntity() -> ModelEntity? {
        // Ładujemy teksturę planety z katalogu zasobów projektu
        guard let textureResource = try? TextureResource.load(named: textureName) else {
            print("Nie udało się załadować tekstury \(textureName)")
            return nil
        }
        
        // Tworzymy materiał oparty na PhysicallyBasedMaterial
        var material = PhysicallyBasedMaterial()
        material.baseColor = .init(texture: .init(textureResource))
        
        // Generujemy siatkę kuli o zadanym promieniu
        let sphereMesh = MeshResource.generateSphere(radius: radius)
        let planetEntity = ModelEntity(mesh: sphereMesh, materials: [material])
        
        // Ustawiamy początkową pozycję – na orbicie, zaczynamy od punktu (orbitCenter.x + orbitRadius, orbitCenter.y, orbitCenter.z)
        planetEntity.position = orbitCenter + SIMD3<Float>(orbitRadius, 0, 0)
        
        return planetEntity
    }
    
    // Funkcja aktualizująca pozycję i obrót planety na podstawie upływającego czasu
    func update(elapsed: Float) {
        guard let planetEntity = self.entity else { return }
        
        // Obliczamy kąt dla orbity
        let angle = elapsed * orbitSpeed
        // Nowa pozycja na orbicie w płaszczyźnie xz
        let newX = orbitCenter.x + orbitRadius * cos(angle)
        let newZ = orbitCenter.z + orbitRadius * sin(angle)
        planetEntity.position = SIMD3<Float>(newX, orbitCenter.y, newZ)
        
        // Obrót planety wokół własnej osi (zakładamy obrót wokół osi Y)
        let rotationAngle = elapsed * selfRotationSpeed
        planetEntity.orientation = simd_quatf(angle: rotationAngle, axis: SIMD3<Float>(0, 1, 0))
    }
}
*/

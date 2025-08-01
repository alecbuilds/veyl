//
//  HeroScene.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SpriteKit
import SwiftUI

class HeroScene: SKScene {
    
    private var emberEmitter: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        setupScene()
        setupEmberParticles()
    }
    
    private func setupScene() {
        // Keep background clear so SwiftUI background shows through
        backgroundColor = .clear
        
        // Set scene size to match view
        size = CGSize(width: 400, height: 800) // Will be scaled to fit
        scaleMode = .aspectFill
    }
    

    
    private func setupEmberParticles() {
        // Create ember emitter programmatically
        emberEmitter = SKEmitterNode()
        
        // Position on the left side, moved up about an inch (72 points)
        emberEmitter.position = CGPoint(x: size.width * 0.25, y: 172)
        
        // Particle properties
        emberEmitter.particleTexture = createEmberTexture()
        emberEmitter.particleBirthRate = 20 // More embers
        emberEmitter.numParticlesToEmit = 0 // Infinite
        
        // Particle lifetime and movement - longer to ensure they reach edges
        emberEmitter.particleLifetime = 6.0
        emberEmitter.particleLifetimeRange = 2.0
        
        // Initial velocity - more realistic fire ember spread
        emberEmitter.particleSpeed = 35
        emberEmitter.particleSpeedRange = 25 // Much more variation
        emberEmitter.emissionAngle = CGFloat.pi / 2 // Straight up as base
        emberEmitter.emissionAngleRange = CGFloat.pi / 2 // Wide spread (90 degrees each side)
        
        // Size properties - keep same size as requested
        emberEmitter.particleScale = 0.08
        emberEmitter.particleScaleRange = 0.03
        emberEmitter.particleScaleSpeed = -0.01 // Shrink over time
        
        // Color properties (orange/red embers)
        emberEmitter.particleColorRedRange = 0.3
        emberEmitter.particleColorGreenRange = 0.2
        emberEmitter.particleColorBlueRange = 0.0
        emberEmitter.particleColorAlphaRange = 0.3
        
        emberEmitter.particleColorRedSpeed = -0.08
        emberEmitter.particleColorGreenSpeed = -0.08
        emberEmitter.particleColorAlphaSpeed = -0.15 // Fade out over time
        
        // More realistic fire ember physics
        emberEmitter.xAcceleration = 0 // No forced horizontal drift
        emberEmitter.yAcceleration = -5 // Slight gravity for realistic arc
        
        // Larger spawn area for fire source
        emberEmitter.particlePositionRange = CGVector(dx: 60, dy: 15)
        
        // Blend mode for glowing effect
        emberEmitter.particleBlendMode = .add
        
        addChild(emberEmitter)
    }
    
    private func createEmberTexture() -> SKTexture {
        // Create a simple circular ember texture
        let size = CGSize(width: 8, height: 8)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return SKTexture()
        }
        
        // Draw a small orange circle
        context.setFillColor(UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 0.8).cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image ?? UIImage())
    }
    

}

// SwiftUI wrapper for the SpriteKit scene
struct HeroSceneView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.backgroundColor = .clear
        view.allowsTransparency = true
        
        let scene = HeroScene()
        scene.backgroundColor = .clear
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // No updates needed
    }
}
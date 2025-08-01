//
//  EmblemNode.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SpriteKit
import SwiftUI

class EmblemNode: SKSpriteNode {
    private var emberEmitter: SKEmitterNode!
    
    init(imageName: String = "emblem_1_5") {
        // Create texture from the image name
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        setupEmblem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupEmblem()
    }
    
    private func setupEmblem() {
        // Center the emblem
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // Start the pulsing glow effect
        startPulsingAnimation()
        
        // Add ember particle effect
        setupEmberParticles()
    }
    
    private func startPulsingAnimation() {
        // Create subtle pulsing animation (1.0 → 1.03 → 1.0)
        let scaleUp = SKAction.scale(to: 1.03, duration: 2.0)
        scaleUp.timingMode = .easeInEaseOut
        
        let scaleDown = SKAction.scale(to: 1.0, duration: 2.0)
        scaleDown.timingMode = .easeInEaseOut
        
        let pulseSequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatPulse = SKAction.repeatForever(pulseSequence)
        
        run(repeatPulse, withKey: "pulse")
    }
    
    private func setupEmberParticles() {
        emberEmitter = SKEmitterNode()
        
        // Position the emitter at the center of the emblem
        emberEmitter.position = CGPoint(x: 0, y: 0)
        
        // Create faint ember particles
        emberEmitter.particleTexture = createFaintEmberTexture()
        emberEmitter.particleBirthRate = 3 // Very few embers for subtlety
        emberEmitter.numParticlesToEmit = 0 // Infinite
        
        // Slow, rising motion
        emberEmitter.particleLifetime = 4.0
        emberEmitter.particleLifetimeRange = 2.0
        
        // Slow upward movement
        emberEmitter.particleSpeed = 8
        emberEmitter.particleSpeedRange = 5
        emberEmitter.emissionAngle = CGFloat.pi / 2 // Straight up
        emberEmitter.emissionAngleRange = CGFloat.pi / 6 // Narrow spread
        
        // Tiny glowing specks
        emberEmitter.particleScale = 0.03
        emberEmitter.particleScaleRange = 0.015
        emberEmitter.particleScaleSpeed = -0.005 // Slowly shrink
        
        // Warm, faint colors
        emberEmitter.particleColorRedRange = 0.2
        emberEmitter.particleColorGreenRange = 0.1
        emberEmitter.particleColorBlueRange = 0.0
        emberEmitter.particleColorAlphaRange = 0.4
        
        emberEmitter.particleColorRedSpeed = -0.03
        emberEmitter.particleColorGreenSpeed = -0.02
        emberEmitter.particleColorAlphaSpeed = -0.08 // Gentle fade
        
        // Very light physics
        emberEmitter.xAcceleration = 0
        emberEmitter.yAcceleration = -1 // Minimal gravity
        
        // Spawn around the emblem center
        emberEmitter.particlePositionRange = CGVector(dx: 40, dy: 10)
        
        // Additive blend for glow effect
        emberEmitter.particleBlendMode = .add
        
        addChild(emberEmitter)
    }
    
    private func createFaintEmberTexture() -> SKTexture {
        // Create a very small, faint ember texture
        let size = CGSize(width: 4, height: 4)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return SKTexture()
        }
        
        // Faint orange glow
        context.setFillColor(UIColor(red: 1.0, green: 0.6, blue: 0.3, alpha: 0.6).cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image ?? UIImage())
    }
    
    // Public function to update the emblem image for future level changes
    public func updateEmblem(to imageName: String) {
        let newTexture = SKTexture(imageNamed: imageName)
        texture = newTexture
        size = newTexture.size()
    }
}

// MARK: - Emblem Scene
class EmblemScene: SKScene {
    private var emblemNode: EmblemNode!
    
    override func didMove(to view: SKView) {
        setupScene()
        setupEmblem()
    }
    
    private func setupScene() {
        backgroundColor = .clear
        size = CGSize(width: 250, height: 250) // Match the desired emblem size
        scaleMode = .aspectFit
    }
    
    private func setupEmblem() {
        emblemNode = EmblemNode(imageName: "emblem_1_5")
        emblemNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Scale the emblem to fit properly in the 250x250 scene
        // For a 1024x1024 PNG, scale it down to fit nicely with padding
        let targetSize: CGFloat = 220 // Use most of the 250x250 space
        let currentSize = max(emblemNode.size.width, emblemNode.size.height)
        let scale = targetSize / currentSize
        emblemNode.setScale(scale)
        
        addChild(emblemNode)
    }
    
    // Public function to update emblem from outside
    public func updateEmblem(to imageName: String) {
        emblemNode?.updateEmblem(to: imageName)
    }
}

// MARK: - SwiftUI Wrapper
struct EmblemView: UIViewRepresentable {
    let imageName: String
    
    init(imageName: String = "emblem_1_5") {
        self.imageName = imageName
    }
    
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.backgroundColor = .clear
        view.allowsTransparency = true
        
        let scene = EmblemScene()
        scene.backgroundColor = .clear
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // Update emblem if the image name changes
        if let scene = uiView.scene as? EmblemScene {
            scene.updateEmblem(to: imageName)
        }
    }
}
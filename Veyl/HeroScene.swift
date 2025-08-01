//
//  HeroScene.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SpriteKit
import SwiftUI

class HeroScene: SKScene {
    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        backgroundColor = .clear
        size = CGSize(width: 400, height: 800)
        scaleMode = .aspectFill
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
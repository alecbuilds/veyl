//
//  HomeView.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI
import SpriteKit

struct HomeView: View {
    @State private var currentXP: Double = 0.87 // XP progress (0.0 - 1.0)
    @State private var currentLevel: Int = 1
    @State private var flickerOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // Background image that fills the entire screen
            Image("levels1_5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            // SpriteKit scene with atmospheric effects
            HeroSceneView()
                .ignoresSafeArea(.all)
                .allowsHitTesting(false) // Allow touches to pass through
            
            // Subtle black overlay for better text contrast
            Color.black.opacity(0.12)
                .ignoresSafeArea(.all)
            
            // XP Bar at the top
            VStack {
                XPBar(
                    currentXP: currentXP,
                    currentLevel: currentLevel,
                    flickerOpacity: flickerOpacity
                )
                .padding(.top, 20) // Space from top safe area
                .padding(.horizontal, 8) // Minimal side margins
                
                Spacer()
            }
        }
        .onAppear {
            startFlickerEffect()
        }
    }
    
    private func startFlickerEffect() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...1.0), repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                flickerOpacity = Double.random(in: 0.9...1.0)
            }
            startFlickerEffect() // Recursive call for continuous flicker
        }
    }
}

struct XPBar: View {
    let currentXP: Double
    let currentLevel: Int
    let flickerOpacity: Double
    
    private let barHeight: CGFloat = 80 // Much bigger bar
    
    var body: some View {
        VStack(spacing: 0) {
            // XP Bar Container
            GeometryReader { geometry in
                ZStack {
                    // XP Fill (ember gradient) - positioned in the center channel
                    HStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.3, green: 0.05, blue: 0.05), // Darker red
                                        Color(red: 0.7, green: 0.25, blue: 0.05), // Muted orange
                                        Color(red: 0.8, green: 0.5, blue: 0.1)     // Dimmed yellow
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: (geometry.size.width * 0.57) * currentXP,
                                height: 20
                            )
                            .opacity(flickerOpacity * 0.85) // Darker base opacity
                            .animation(.easeInOut(duration: 0.5), value: currentXP)
                            .animation(.easeInOut(duration: 0.3), value: flickerOpacity)
                            .shadow(color: .orange.opacity(0.4), radius: 3, x: 0, y: 0) // Reduced glow
                            .shadow(color: .black.opacity(0.6), radius: 2, x: 1, y: 1) // Dark shadow for depth
                            .padding(.leading, geometry.size.width * 0.23)
                        
                        Spacer()
                    }
                    .offset(y: -8)
                    
                    // Subtle ember particles for XP bar
                    XPBarEmberView()
                        .frame(width: geometry.size.width, height: barHeight)
                        .allowsHitTesting(false)
                        .clipped()
                    
                    // Frame overlay with dark fantasy effects
                    ZStack {
                        // Frame with VHS-style effects
                        Image("xp_bar_frame")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width, height: barHeight)
                            .opacity(0.9) // Slightly transparent for aged look
                            .shadow(color: .black.opacity(0.8), radius: 4, x: 2, y: 2) // Deep shadow
                        
                        // Dark overlay for VHS texture effect
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.black.opacity(0.0), location: 0.0),
                                        .init(color: Color.black.opacity(0.15), location: 0.3),
                                        .init(color: Color.black.opacity(0.05), location: 0.7),
                                        .init(color: Color.black.opacity(0.2), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: geometry.size.width, height: barHeight)
                            .blendMode(.multiply) // Dark fantasy texture
                        
                        // Subtle noise/grain overlay
                        Rectangle()
                            .fill(Color.gray.opacity(0.08))
                            .frame(width: geometry.size.width, height: barHeight)
                            .blendMode(.overlay)
                    }
                }
            }
            .frame(height: barHeight)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - XP Bar Ember Scene
class XPBarEmberScene: SKScene {
    private var emberEmitter: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        setupScene()
        setupXPEmberParticles()
    }
    
    private func setupScene() {
        backgroundColor = .clear
        size = CGSize(width: 400, height: 80) // Match XP bar dimensions
        scaleMode = .aspectFill
    }
    
    private func setupXPEmberParticles() {
        emberEmitter = SKEmitterNode()
        
        // Position along the center channel of the XP bar
        emberEmitter.position = CGPoint(x: size.width * 0.5, y: size.height * 0.3)
        
        // More visible particle properties for XP bar
        emberEmitter.particleTexture = createSubtleEmberTexture()
        emberEmitter.particleBirthRate = 8 // More embers for visibility
        emberEmitter.numParticlesToEmit = 0
        
        // Longer lifetime so we can see them
        emberEmitter.particleLifetime = 3.0
        emberEmitter.particleLifetimeRange = 1.5
        
        // More noticeable movement
        emberEmitter.particleSpeed = 15
        emberEmitter.particleSpeedRange = 10
        emberEmitter.emissionAngle = CGFloat.pi / 2 // Upward
        emberEmitter.emissionAngleRange = CGFloat.pi / 4 // Wider spread for visibility
        
        // Larger particles for visibility
        emberEmitter.particleScale = 0.08
        emberEmitter.particleScaleRange = 0.03
        emberEmitter.particleScaleSpeed = -0.01
        
        // Brighter colors for visibility
        emberEmitter.particleColorRedRange = 0.3
        emberEmitter.particleColorGreenRange = 0.2
        emberEmitter.particleColorBlueRange = 0.0
        emberEmitter.particleColorAlphaRange = 0.6
        
        emberEmitter.particleColorRedSpeed = -0.05
        emberEmitter.particleColorGreenSpeed = -0.05
        emberEmitter.particleColorAlphaSpeed = -0.15
        
        // Light physics for floating effect
        emberEmitter.xAcceleration = 0
        emberEmitter.yAcceleration = -3
        
        // Spawn along the XP bar center
        emberEmitter.particlePositionRange = CGVector(dx: size.width * 0.5, dy: 8)
        
        emberEmitter.particleBlendMode = .add
        
        addChild(emberEmitter)
    }
    
    private func createSubtleEmberTexture() -> SKTexture {
        let size = CGSize(width: 8, height: 8) // Larger for visibility
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return SKTexture()
        }
        
        // Brighter orange glow for visibility
        context.setFillColor(UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 0.9).cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image ?? UIImage())
    }
}

// SwiftUI wrapper for XP Bar ember scene
struct XPBarEmberView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.backgroundColor = .clear
        view.allowsTransparency = true
        
        let scene = XPBarEmberScene()
        scene.backgroundColor = .clear
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // No updates needed
    }
}

#Preview {
    HomeView()
}
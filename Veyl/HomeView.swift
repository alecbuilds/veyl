//
//  HomeView.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI
import SpriteKit

struct HomeView: View {
    @State private var currentXP: Double = 0.0 // XP progress (0.0 - 1.0) - start at 0% for LVL 1
    @State private var currentLevel: Int = 1
    @State private var flickerOpacity: Double = 1.0
    @State private var currentScale: Double = 1.0
    
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
            
            // Veyl Logo - Top Left (Professional branding placement with proper safe area)
            GeometryReader { geometry in
                VStack {
                    HStack {
                        Image("veyl_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100) // Slightly larger logo size
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1) // Strong contrast shadow
                            .shadow(color: .white.opacity(0.3), radius: 4, x: 0, y: 0) // White glow for visibility
                            .shadow(color: .orange.opacity(0.2), radius: 8, x: 0, y: 0) // Subtle brand glow
                        
                        Spacer()
                    }
                    .padding(.top, geometry.safeAreaInsets.top - 74) // Move up by quarter inch more (56 + 18 = 74, since 18pt = 0.25 inch)
                    .padding(.leading, 56) // Move left by another quarter inch (74 - 18 = 56pt)
                    .background(
                        // Subtle background for better logo visibility
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.black.opacity(0.15))
                            .blur(radius: 4)
                            .padding(-8)
                    )
                    
                    Spacer()
                }
            }
            .zIndex(100) // Ensure logo appears above everything else
            
            // Main content layout
            VStack {
                Spacer()
                    .frame(height: 80) // Space from top safe area - moved emblem down slightly
                
                // Centered Emblem at the top
                ZStack {
                    // Main emblem image
                    Image("emblem_1_5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: 280) // Larger size
                        .scaleEffect(currentScale)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: currentScale)
                    
                    // Ember particles overlay
                    EmblemEmberView()
                        .frame(width: 320, height: 320) // Larger particle area
                        .allowsHitTesting(false)
                }
                .allowsHitTesting(false) // Allow touches to pass through
                
                Spacer()
                    .frame(height: 20) // Reduced space between emblem and XP bar
                
                // Original XP Bar - commented out
                /*
                XPBar(
                    currentXP: currentXP,
                    currentLevel: currentLevel,
                    flickerOpacity: flickerOpacity
                )
                .padding(.horizontal, 8) // Minimal side margins
                */
                
                // Custom Dark Fantasy XP Bar
                DarkFantasyXPBar(
                    currentXP: currentXP,
                    currentLevel: currentLevel
                )
                .padding(.horizontal, 40) // More padding to keep it away from edges
                
                Spacer()
            }
        }
        .onAppear {
            startFlickerEffect()
            startEmblemPulsing()
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
    
    private func startEmblemPulsing() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            currentScale = 1.03
        }
    }
    
    // MARK: - XP System (Future-proofed)
    /// Simple method to update XP progress and level
    /// - Parameters:
    ///   - xp: XP progress from 0.0 to 1.0
    ///   - level: Current player level
    private func updateXP(to xp: Double, level: Int) {
        withAnimation(.easeInOut(duration: 0.8)) {
            currentXP = min(max(xp, 0.0), 1.0) // Clamp between 0.0 and 1.0
            currentLevel = level
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
                        
                        // Very subtle dark overlay for VHS texture effect
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: Color.black.opacity(0.0), location: 0.0),
                                        .init(color: Color.black.opacity(0.03), location: 0.4),
                                        .init(color: Color.black.opacity(0.01), location: 0.6),
                                        .init(color: Color.black.opacity(0.05), location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: geometry.size.width, height: barHeight)
                            .blendMode(.multiply) // Very subtle dark fantasy texture
                        
                        // Minimal noise/grain overlay
                        Rectangle()
                            .fill(Color.gray.opacity(0.02))
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

// MARK: - Emblem Ember Scene
class EmblemEmberScene: SKScene {
    private var emberEmitter: SKEmitterNode!
    
    override func didMove(to view: SKView) {
        setupScene()
        setupEmblemEmberParticles()
    }
    
    private func setupScene() {
        backgroundColor = .clear
        size = CGSize(width: 250, height: 250)
        scaleMode = .aspectFit
    }
    
    private func setupEmblemEmberParticles() {
        emberEmitter = SKEmitterNode()
        
        // Position at center of emblem
        emberEmitter.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Faint ember particle properties
        emberEmitter.particleTexture = createFaintEmberTexture()
        emberEmitter.particleBirthRate = 3 // Very few embers for subtlety
        emberEmitter.numParticlesToEmit = 0
        
        // Slow rising motion
        emberEmitter.particleLifetime = 4.0
        emberEmitter.particleLifetimeRange = 2.0
        
        emberEmitter.particleSpeed = 8
        emberEmitter.particleSpeedRange = 5
        emberEmitter.emissionAngle = CGFloat.pi / 2 // Upward
        emberEmitter.emissionAngleRange = CGFloat.pi / 6 // Narrow spread
        
        // Tiny glowing specks
        emberEmitter.particleScale = 0.03
        emberEmitter.particleScaleRange = 0.015
        emberEmitter.particleScaleSpeed = -0.005
        
        // Warm, faint colors
        emberEmitter.particleColorRedRange = 0.2
        emberEmitter.particleColorGreenRange = 0.1
        emberEmitter.particleColorBlueRange = 0.0
        emberEmitter.particleColorAlphaRange = 0.4
        
        emberEmitter.particleColorRedSpeed = -0.03
        emberEmitter.particleColorGreenSpeed = -0.02
        emberEmitter.particleColorAlphaSpeed = -0.08
        
        // Very light physics
        emberEmitter.xAcceleration = 0
        emberEmitter.yAcceleration = -1
        
        // Spawn around the emblem center
        emberEmitter.particlePositionRange = CGVector(dx: 40, dy: 10)
        
        emberEmitter.particleBlendMode = .add
        
        addChild(emberEmitter)
    }
    
    private func createFaintEmberTexture() -> SKTexture {
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
}

// SwiftUI wrapper for emblem ember scene
struct EmblemEmberView: UIViewRepresentable {
    func makeUIView(context: Context) -> SKView {
        let view = SKView()
        view.backgroundColor = .clear
        view.allowsTransparency = true
        
        let scene = EmblemEmberScene()
        scene.backgroundColor = .clear
        
        view.presentScene(scene)
        view.ignoresSiblingOrder = true
        
        return view
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        // No updates needed
    }
}

// MARK: - 8-Bit Style XP Bar
struct DarkFantasyXPBar: View {
    let currentXP: Double
    let currentLevel: Int
    
    private let barHeight: CGFloat = 24
    private let barWidth: CGFloat = 200 // Fixed width to stay centered
    private let totalSegments = 20 // Number of 8-bit chunks
    private let segmentSpacing: CGFloat = 1
    
    private var filledSegments: Int {
        Int(currentXP * Double(totalSegments))
    }
    
    private var segmentWidth: CGFloat {
        (barWidth - CGFloat(totalSegments - 1) * segmentSpacing) / CGFloat(totalSegments)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Level indicator - retro gaming style
            HStack {
                Text("LVL \(currentLevel)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                
                Spacer()
                
                Text("\(Int(currentXP * 100))%")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .black, radius: 1, x: 1, y: 1)
            }
            .frame(width: barWidth) // Match the bar width
            
            // 8-Bit Progress Bar - chunky segments
            VStack(spacing: 0) {
                // Top border
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: barWidth + 2, height: 1)
                
                HStack(spacing: 0) {
                    // Left border
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 1, height: barHeight)
                    
                    // Segmented progress bar
                    HStack(spacing: segmentSpacing) {
                        ForEach(0..<totalSegments, id: \.self) { index in
                            Rectangle()
                                .fill(segmentColor(for: index))
                                .frame(width: segmentWidth, height: barHeight)
                                .overlay(
                                    // Subtle preview hint for empty segments
                                    Rectangle()
                                        .fill(segmentPreviewColor(for: index))
                                        .opacity(index >= filledSegments ? 1.0 : 0.0)
                                )
                                .animation(.easeInOut(duration: 0.1).delay(Double(index) * 0.02), value: currentXP)
                        }
                    }
                    .background(Color.black.opacity(0.8)) // Dark background for empty segments
                    
                    // Right border
                    Rectangle()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 1, height: barHeight)
                }
                
                // Bottom border
                Rectangle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: barWidth + 2, height: 1)
            }
            .shadow(color: .black.opacity(0.6), radius: 3, x: 1, y: 2)
        }
    }
    
    private func segmentColor(for index: Int) -> Color {
        guard index < filledSegments else { return Color.clear }
        
        // Dark fantasy color progression
        let progress = Double(index) / Double(totalSegments)
        
        if progress < 0.3 {
            // Deep crimson for low XP
            return Color(red: 0.8, green: 0.2, blue: 0.2).opacity(0.9)
        } else if progress < 0.7 {
            // Molten gold for medium XP
            return Color(red: 1.0, green: 0.6, blue: 0.1).opacity(0.9)
        } else {
            // Ethereal emerald for high XP
            return Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.9)
        }
    }
    
    private func segmentPreviewColor(for index: Int) -> Color {
        // Subtle preview hint for what the bar will look like when filled
        let progress = Double(index) / Double(totalSegments)
        
        if progress < 0.3 {
            // Faint crimson preview
            return Color(red: 0.8, green: 0.2, blue: 0.2).opacity(0.15)
        } else if progress < 0.7 {
            // Faint gold preview
            return Color(red: 1.0, green: 0.6, blue: 0.1).opacity(0.15)
        } else {
            // Faint emerald preview
            return Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.15)
        }
    }
}

#Preview {
    HomeView()
}
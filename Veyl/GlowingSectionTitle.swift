//
//  GlowingSectionTitle.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

class GlowingSectionTitle: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: max(size.width, 300), height: max(size.height, 40)) // Fixed minimum size
    }
    
    init(text: String) {
        super.init(frame: .zero)
        setupGlowingTitle(text: text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGlowingTitle(text: "◄ LIFE STATS ►")
    }
    
    private func setupGlowingTitle(text: String) {
        self.text = text
        
        // 8-bit font styling
        font = UIFont.monospacedSystemFont(ofSize: 16, weight: .bold)
        textColor = UIColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1.0) // #e6ccff
        textAlignment = .center
        
        // Force pixelated rendering
        layer.magnificationFilter = .nearest
        layer.minificationFilter = .nearest
        
        // Add the primary text shadow (black outline)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0
        
        // Add letter spacing for that authentic look
        setLetterSpacing(2.0)
        
        // Add the mystical glow effect
        addMysticalGlow()
        
        // Start the pulsing animation
        startGlowAnimation()
    }
    
    private func addMysticalGlow() {
        // Create multiple glow layers for that mystical effect
        let glowLayer1 = CALayer()
        glowLayer1.frame = bounds
        glowLayer1.shadowColor = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 1.0).cgColor // #9966cc
        glowLayer1.shadowOffset = CGSize.zero
        glowLayer1.shadowOpacity = 0.8
        glowLayer1.shadowRadius = 10
        layer.insertSublayer(glowLayer1, at: 0)
        
        let glowLayer2 = CALayer()
        glowLayer2.frame = bounds
        glowLayer2.shadowColor = UIColor(red: 0.4, green: 0.27, blue: 0.67, alpha: 1.0).cgColor // #6644aa
        glowLayer2.shadowOffset = CGSize.zero
        glowLayer2.shadowOpacity = 0.6
        glowLayer2.shadowRadius = 20
        layer.insertSublayer(glowLayer2, at: 0)
    }
    
    private func startGlowAnimation() {
        // Create the pulsing glow animation
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 10
        glowAnimation.toValue = 20
        glowAnimation.duration = 2.0
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        glowAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Apply to all glow layers
        layer.sublayers?.forEach { sublayer in
            sublayer.add(glowAnimation, forKey: "mysticalGlow")
        }
        
        // Also animate the main shadow for extra effect
        let mainShadowGlow = CABasicAnimation(keyPath: "shadowRadius")
        mainShadowGlow.fromValue = 0
        mainShadowGlow.toValue = 5
        mainShadowGlow.duration = 2.0
        mainShadowGlow.autoreverses = true
        mainShadowGlow.repeatCount = .infinity
        mainShadowGlow.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(mainShadowGlow, forKey: "mainGlow")
        
        // Add subtle color pulsing
        let colorAnimation = CABasicAnimation(keyPath: "shadowColor")
        colorAnimation.fromValue = UIColor(red: 0.6, green: 0.4, blue: 0.8, alpha: 0.8).cgColor
        colorAnimation.toValue = UIColor(red: 0.73, green: 0.53, blue: 1.0, alpha: 1.0).cgColor // #bb88ff
        colorAnimation.duration = 3.0
        colorAnimation.autoreverses = true
        colorAnimation.repeatCount = .infinity
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.sublayers?.first?.add(colorAnimation, forKey: "colorPulse")
    }
    
    private func setLetterSpacing(_ spacing: CGFloat) {
        guard let text = self.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.kern, 
                                    value: spacing, 
                                    range: NSRange(location: 0, length: text.count))
        
        // Keep the glow color
        attributedString.addAttribute(.foregroundColor, 
                                    value: UIColor(red: 0.9, green: 0.8, blue: 1.0, alpha: 1.0),
                                    range: NSRange(location: 0, length: text.count))
        
        self.attributedText = attributedString
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update glow layer frames when view resizes
        layer.sublayers?.forEach { sublayer in
            sublayer.frame = bounds
        }
    }
}
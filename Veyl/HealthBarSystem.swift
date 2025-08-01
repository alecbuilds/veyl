//
//  HealthBarSystem.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI
import UIKit

class HealthBarContainerView: UIView {
    override var intrinsicContentSize: CGSize {
        // Calculate total height: XP bar (80) + spacer (16) + title (40) + spacer (8) + 6 health bars (56 each) + spacing (12 * 5) + padding (40)
        let xpBarHeight: CGFloat = 80
        let titleHeight: CGFloat = 40
        let healthBarHeight: CGFloat = 56
        let numberOfHealthBars: CGFloat = 6
        let spacingBetweenBars: CGFloat = 12
        let spacerHeights: CGFloat = 16 + 8
        let padding: CGFloat = 40
        
        let totalHeight = xpBarHeight + spacerHeights + titleHeight + (healthBarHeight * numberOfHealthBars) + (spacingBetweenBars * (numberOfHealthBars + 1)) + padding
        let totalWidth: CGFloat = 400 // Fixed width to prevent expansion issues
        
        return CGSize(width: totalWidth, height: totalHeight)
    }
}

struct HealthBarSystem: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let containerView = HealthBarContainerView()
        containerView.backgroundColor = .clear
        
        setupHealthBars(in: containerView)
        
        return containerView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Health bars are static for now, but this could be used for updates
    }
    
    private func setupHealthBars(in containerView: UIView) {
        let barConfigs = [
            ("heart.fill", UIColor.pixel8BitRed, "Health"),
            ("dumbbell.fill", UIColor.pixel8BitOrange, "Strength"),
            ("brain.head.profile", UIColor.pixel8BitPurple, "Focus"),
            ("moon.fill", UIColor.pixel8BitBlue, "Sleep"),
            ("lightbulb.fill", UIColor.pixel8BitYellow, "Clarity"),
            ("drop.fill", UIColor.pixel8BitCyan, "Hydration")
        ]
        
        // Create XP bar
        let xpBar = MysticalXPBar()
        xpBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Create glowing title label
        let titleLabel = GlowingSectionTitle(text: "◄ LIFE STATS ►")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add XP bar first
        stackView.addArrangedSubview(xpBar)
        
        // Set XP bar height constraint
        NSLayoutConstraint.activate([
            xpBar.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Add some spacing after XP bar
        let xpSpacer = UIView()
        xpSpacer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            xpSpacer.heightAnchor.constraint(equalToConstant: 16)
        ])
        stackView.addArrangedSubview(xpSpacer)
        
        // Add title
        stackView.addArrangedSubview(titleLabel)
        
        // Add some spacing after title
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spacer.heightAnchor.constraint(equalToConstant: 8)
        ])
        stackView.addArrangedSubview(spacer)
        
        var bars: [PixelHealthBar] = []
        
        for (symbol, color, type) in barConfigs {
            let healthBar = PixelHealthBar(sfSymbol: symbol, color: color, barType: type)
            bars.append(healthBar)
            stackView.addArrangedSubview(healthBar)
        }
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
        
        // Set some initial static demo values (no animations)
        bars[1].setValue(7, animated: false) // Strength
        bars[2].setValue(5, animated: false) // Focus
        bars[3].setValue(8, animated: false) // Sleep
        bars[4].setValue(6, animated: false) // Clarity
        bars[5].setValue(9, animated: false) // Hydration
    }
}
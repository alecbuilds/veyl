//
//  DarkFantasyTabButton.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

class DarkFantasyTabButton: UIButton {
    
    private let customTitleLabel = UILabel()
    private let iconImageView = UIImageView()
    private var highlightLayer: CALayer?
    private var shadowLayer: CALayer?
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updatePressedState()
        }
    }
    
    init(title: String, icon: UIImage?) {
        super.init(frame: .zero)
        setupButton(title: title, icon: icon)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupButton(title: String, icon: UIImage?) {
        // Button styling exactly like web demo
        backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0) // #333366
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0).cgColor // #666699
        layer.cornerRadius = 6
        
        // 8-bit shadow effects
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0 // Sharp shadow
        
        // Inset shadows for 3D effect
        addInsetShadows()
        
        // Setup title
        customTitleLabel.text = title
        customTitleLabel.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .bold)
        customTitleLabel.textColor = .white
        customTitleLabel.textAlignment = .center
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add text shadow
        customTitleLabel.layer.shadowColor = UIColor.black.cgColor
        customTitleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        customTitleLabel.layer.shadowOpacity = 1.0
        customTitleLabel.layer.shadowRadius = 0
        
        addSubview(customTitleLabel)
        
        NSLayoutConstraint.activate([
            customTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            customTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 38),
            widthAnchor.constraint(equalToConstant: 70)
        ])
        
        updateAppearance()
    }
    
    private func addInsetShadows() {
        // Top-left highlight
        let highlightLayer = CALayer()
        highlightLayer.backgroundColor = UIColor(red: 0.33, green: 0.33, blue: 0.67, alpha: 1.0).cgColor // #5555aa
        layer.addSublayer(highlightLayer)
        self.highlightLayer = highlightLayer
        
        // Bottom-right inner shadow
        let shadowLayer = CALayer()
        shadowLayer.backgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.267, alpha: 1.0).cgColor // #222244
        layer.addSublayer(shadowLayer)
        self.shadowLayer = shadowLayer
    }
    
    private func updateAppearance() {
        if isSelected {
            // Active state styling
            backgroundColor = UIColor(red: 0.33, green: 0.33, blue: 0.8, alpha: 1.0) // #5555cc
            layer.borderColor = UIColor(red: 0.53, green: 0.53, blue: 0.8, alpha: 1.0).cgColor
            customTitleLabel.textColor = UIColor.white
            
            // Enhanced glow for active state
            layer.shadowColor = UIColor(red: 0.33, green: 0.33, blue: 0.8, alpha: 1.0).cgColor
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0.4
            layer.shadowRadius = 8
            
        } else {
            // Normal state styling
            backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0) // #333366
            layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.6, alpha: 1.0).cgColor
            customTitleLabel.textColor = UIColor.white
            
            // Normal shadow
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 2, height: 2)
            layer.shadowOpacity = 1.0
            layer.shadowRadius = 0
        }
    }
    
    private func updatePressedState() {
        if isHighlighted {
            // Pressed state - move button down and right like web demo
            transform = CGAffineTransform(translationX: 1, y: 1)
            layer.shadowOffset = CGSize(width: 1, height: 1)
            backgroundColor = UIColor(red: 0.133, green: 0.133, blue: 0.33, alpha: 1.0) // #222255
        } else {
            // Reset to normal position
            transform = CGAffineTransform.identity
            updateAppearance() // Reset to selected/normal state
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update inset shadow layer frames
        highlightLayer?.frame = CGRect(x: 2, y: 2, width: bounds.width - 4, height: 1)
        shadowLayer?.frame = CGRect(x: 2, y: bounds.height - 3, width: bounds.width - 4, height: 1)
    }
}
//
//  PixelIcon.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

class PixelIcon: UIView {
    private let imageView = UIImageView()
    private let iconSize: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: iconSize, height: iconSize)
    }
    
    init(sfSymbol: String, size: CGFloat = 32, color: UIColor) {
        self.iconSize = size
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        setupPixelIcon(sfSymbol: sfSymbol, color: color)
    }
    
    private func setupPixelIcon(sfSymbol: String, color: UIColor) {
        // Transparent background - no container
        backgroundColor = .clear
        
        // Force pixelated rendering
        layer.magnificationFilter = .nearest
        layer.minificationFilter = .nearest
        layer.shouldRasterize = true
        layer.rasterizationScale = 1.0
        
        // Setup SF Symbol with pixelated look
        let config = UIImage.SymbolConfiguration(pointSize: frame.width * 0.8, weight: .black)
        let icon = UIImage(systemName: sfSymbol, withConfiguration: config)
        
        imageView.image = icon
        imageView.tintColor = color
        imageView.contentMode = .center
        imageView.layer.magnificationFilter = .nearest
        
        // Add 8-bit styling to the icon itself
        addIconBevelEffect(color: color)
        
        // Sharp shadow for depth
        imageView.layer.shadowColor = color.darker(by: 0.5).cgColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 0
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    private func addIconBevelEffect(color: UIColor) {
        // Just add subtle inner glow for depth - no borders or containers
        let innerGlow = CALayer()
        innerGlow.frame = imageView.bounds
        innerGlow.shadowColor = color.withAlphaComponent(0.6).cgColor
        innerGlow.shadowOffset = .zero
        innerGlow.shadowRadius = 0.5
        innerGlow.shadowOpacity = 0.4
        
        // No borders or containers - keep it clean
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
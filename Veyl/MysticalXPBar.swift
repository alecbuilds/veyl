//
//  MysticalXPBar.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

class MysticalXPBar: UIView {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let xpBarBackground = UIView()
    private let xpFillView = UIView()
    private let xpTextLabel = UILabel()
    private let borderGradientLayer = CAGradientLayer()
    private let shimmerLayer = CAGradientLayer()
    private var fillGradientLayer: CAGradientLayer?
    
    private var currentXP: Int = 1847
    private var maxXP: Int = 2500
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 80) // Fixed size to match the heightAnchor constraint
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXPBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXPBar()
    }
    
    private func setupXPBar() {
        setupContainer()
        setupTitle()
        setupXPBarBackground()
        setupXPFill()
        setupXPText()
        setupAnimations()
    }
    
    private func setupContainer() {
        // Dark fantasy container with exact colors from web demo
        containerView.backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.133, alpha: 0.8)
        containerView.layer.borderWidth = 3
        containerView.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        containerView.layer.cornerRadius = 8
        
        // Add the mystical border gradient effect
        setupBorderGradient()
        
        // Add inset shadows for depth
        addInsetShadows()
        
        // Add outer glow
        containerView.layer.shadowColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowRadius = 25
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupBorderGradient() {
        borderGradientLayer.colors = [
            UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(red: 0.4, green: 0.4, blue: 0.67, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        ]
        borderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        borderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        borderGradientLayer.cornerRadius = 8
        borderGradientLayer.opacity = 0.3
        
        containerView.layer.insertSublayer(borderGradientLayer, at: 0)
    }
    
    private func addInsetShadows() {
        // Top-left inner highlight
        let highlightLayer = CALayer()
        highlightLayer.backgroundColor = UIColor(red: 0.267, green: 0.267, blue: 0.467, alpha: 1.0).cgColor
        highlightLayer.frame = CGRect(x: 3, y: 3, width: 100, height: 1) // Will be updated in layoutSubviews
        containerView.layer.addSublayer(highlightLayer)
        
        // Bottom-right inner shadow
        let shadowLayer = CALayer()
        shadowLayer.backgroundColor = UIColor.black.cgColor
        shadowLayer.frame = CGRect(x: 3, y: 50, width: 100, height: 1) // Will be updated in layoutSubviews
        containerView.layer.addSublayer(shadowLayer)
    }
    
    private func setupTitle() {
        titleLabel.text = "◄ EXPERIENCE POINTS ►"
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 9, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0) // #ccccff
        titleLabel.textAlignment = .center
        
        // Add text glow
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.shadowRadius = 0
        
        // Letter spacing like web demo
        let attributedString = NSMutableAttributedString(string: titleLabel.text!)
        attributedString.addAttribute(.kern, value: 1.0, range: NSRange(location: 0, length: attributedString.length))
        titleLabel.attributedText = attributedString
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupXPBarBackground() {
        xpBarBackground.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.067, alpha: 1.0) // #000011
        xpBarBackground.layer.borderWidth = 2
        xpBarBackground.layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        xpBarBackground.layer.cornerRadius = 4
        
        // Add inner shadow to background
        xpBarBackground.layer.shadowColor = UIColor(red: 0.067, green: 0.067, blue: 0.133, alpha: 1.0).cgColor
        xpBarBackground.layer.shadowOffset = CGSize(width: 2, height: 2)
        xpBarBackground.layer.shadowOpacity = 1.0
        xpBarBackground.layer.shadowRadius = 0
        
        xpBarBackground.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(xpBarBackground)
        
        NSLayoutConstraint.activate([
            xpBarBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            xpBarBackground.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            xpBarBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            xpBarBackground.heightAnchor.constraint(equalToConstant: 20),
            xpBarBackground.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupXPFill() {
        // Set background color for the fill view first
        xpFillView.backgroundColor = UIColor(red: 1.0, green: 0.843, blue: 0.0, alpha: 1.0) // Fallback gold color
        
        // Multi-layer gradient like the web demo - exact colors from prompt
        fillGradientLayer = CAGradientLayer()
        fillGradientLayer!.colors = [
            UIColor(red: 1.0, green: 0.843, blue: 0.0, alpha: 1.0).cgColor,   // #ffd700
            UIColor(red: 1.0, green: 0.929, blue: 0.29, alpha: 1.0).cgColor,  // #ffed4a  
            UIColor(red: 1.0, green: 0.667, blue: 0.0, alpha: 1.0).cgColor    // #ffaa00
        ]
        fillGradientLayer!.startPoint = CGPoint(x: 0, y: 0)
        fillGradientLayer!.endPoint = CGPoint(x: 0, y: 1)
        fillGradientLayer!.locations = [0.0, 0.5, 1.0]
        fillGradientLayer!.cornerRadius = 2
        
        // Ensure gradient layer is added properly
        xpFillView.layer.insertSublayer(fillGradientLayer!, at: 0)
        
        // Remove border to let gradient show through
        xpFillView.layer.borderWidth = 0
        xpFillView.layer.cornerRadius = 2
        
        // Add inner highlight
        addXPFillHighlight()
        
        // Add outer glow
        xpFillView.layer.shadowColor = UIColor(red: 1.0, green: 0.843, blue: 0.0, alpha: 1.0).cgColor
        xpFillView.layer.shadowOffset = CGSize.zero
        xpFillView.layer.shadowOpacity = 0.3
        xpFillView.layer.shadowRadius = 4
        
        xpFillView.clipsToBounds = true // Changed to true to contain the gradient
        xpFillView.translatesAutoresizingMaskIntoConstraints = false
        xpBarBackground.addSubview(xpFillView)
        
        // Calculate the fill percentage (73% from web demo)
        let fillPercentage = CGFloat(currentXP) / CGFloat(maxXP)
        
        NSLayoutConstraint.activate([
            xpFillView.topAnchor.constraint(equalTo: xpBarBackground.topAnchor, constant: 2),
            xpFillView.leadingAnchor.constraint(equalTo: xpBarBackground.leadingAnchor, constant: 2),
            xpFillView.bottomAnchor.constraint(equalTo: xpBarBackground.bottomAnchor, constant: -2),
            xpFillView.widthAnchor.constraint(equalTo: xpBarBackground.widthAnchor, multiplier: fillPercentage, constant: -4)
        ])
        
        // Setup shimmer animation
        setupShimmerEffect(on: fillGradientLayer!)
    }
    
    private func addXPFillHighlight() {
        let highlightLayer = CALayer()
        highlightLayer.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.533, alpha: 0.6).cgColor // rgba(255, 255, 136, 0.6)
        highlightLayer.frame = CGRect(x: 2, y: 2, width: 100, height: 2) // Will be updated in layoutSubviews
        highlightLayer.cornerRadius = 1
        xpFillView.layer.addSublayer(highlightLayer)
    }
    
    private func setupShimmerEffect(on gradientLayer: CAGradientLayer) {
        // Create shimmer gradient
        shimmerLayer.colors = [
            UIColor(red: 1.0, green: 0.843, blue: 0.0, alpha: 0.8).cgColor,
            UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0).cgColor,
            UIColor(red: 1.0, green: 0.843, blue: 0.0, alpha: 0.8).cgColor
        ]
        shimmerLayer.startPoint = CGPoint(x: -1, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.locations = [0.0, 0.5, 1.0]
        
        gradientLayer.addSublayer(shimmerLayer)
    }
    
    private func setupXPText() {
        xpTextLabel.text = "\(currentXP) / \(maxXP) XP"
        xpTextLabel.font = UIFont.monospacedSystemFont(ofSize: 9, weight: .bold)
        xpTextLabel.textColor = UIColor.black
        xpTextLabel.textAlignment = .center
        
        // White text shadow for contrast
        xpTextLabel.layer.shadowColor = UIColor.white.cgColor
        xpTextLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        xpTextLabel.layer.shadowOpacity = 1.0
        xpTextLabel.layer.shadowRadius = 0
        
        xpTextLabel.translatesAutoresizingMaskIntoConstraints = false
        xpBarBackground.addSubview(xpTextLabel)
        
        NSLayoutConstraint.activate([
            xpTextLabel.centerXAnchor.constraint(equalTo: xpBarBackground.centerXAnchor),
            xpTextLabel.centerYAnchor.constraint(equalTo: xpBarBackground.centerYAnchor)
        ])
    }
    
    private func setupAnimations() {
        // XP Bar shimmer animation (like web demo)
        let shimmerAnimation = CABasicAnimation(keyPath: "opacity")
        shimmerAnimation.fromValue = 1.0
        shimmerAnimation.toValue = 0.9
        shimmerAnimation.duration = 2.0
        shimmerAnimation.autoreverses = true
        shimmerAnimation.repeatCount = .infinity
        shimmerAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Apply to the fill view
        xpFillView.layer.add(shimmerAnimation, forKey: "xpShimmer")
        
        // Shimmer sweep effect
        let sweepAnimation = CABasicAnimation(keyPath: "startPoint")
        sweepAnimation.fromValue = CGPoint(x: -1, y: 0.5)
        sweepAnimation.toValue = CGPoint(x: 1, y: 0.5)
        sweepAnimation.duration = 3.0
        sweepAnimation.repeatCount = .infinity
        sweepAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        shimmerLayer.add(sweepAnimation, forKey: "shimmerSweep")
        
        // Border gradient animation
        let borderAnimation = CABasicAnimation(keyPath: "opacity")
        borderAnimation.fromValue = 0.3
        borderAnimation.toValue = 0.6
        borderAnimation.duration = 2.5
        borderAnimation.autoreverses = true
        borderAnimation.repeatCount = .infinity
        borderAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        borderGradientLayer.add(borderAnimation, forKey: "borderGlow")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update border gradient frame
        borderGradientLayer.frame = containerView.bounds
        
        // Update XP fill gradient layer frame
        if let fillGradient = fillGradientLayer {
            fillGradient.frame = xpFillView.bounds
            
            // Update shimmer layer frame
            shimmerLayer.frame = fillGradient.bounds
        }
        
        // Update highlight layer frame
        xpFillView.layer.sublayers?.forEach { layer in
            if layer.backgroundColor == UIColor(red: 1.0, green: 1.0, blue: 0.533, alpha: 0.6).cgColor {
                layer.frame = CGRect(x: 0, y: 0, width: xpFillView.bounds.width, height: 2)
            }
        }
        
        // Update inset shadow layers
        containerView.layer.sublayers?.forEach { layer in
            if layer.backgroundColor == UIColor(red: 0.267, green: 0.267, blue: 0.467, alpha: 1.0).cgColor {
                layer.frame = CGRect(x: 3, y: 3, width: containerView.bounds.width - 6, height: 1)
            } else if layer.backgroundColor == UIColor.black.cgColor {
                layer.frame = CGRect(x: 3, y: containerView.bounds.height - 4, width: containerView.bounds.width - 6, height: 1)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func updateXP(current: Int, max: Int, animated: Bool = true) {
        let oldPercentage = CGFloat(currentXP) / CGFloat(maxXP)
        
        currentXP = current
        maxXP = max
        
        let newPercentage = CGFloat(currentXP) / CGFloat(maxXP)
        
        // Update text
        xpTextLabel.text = "\(currentXP) / \(maxXP) XP"
        
        if animated {
            animateXPChange(from: oldPercentage, to: newPercentage)
        } else {
            updateXPFillWidth(percentage: newPercentage)
        }
    }
    
    private func animateXPChange(from oldPercentage: CGFloat, to newPercentage: CGFloat) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.updateXPFillWidth(percentage: newPercentage)
        }
    }
    
    private func updateXPFillWidth(percentage: CGFloat) {
        xpFillView.constraints.forEach { constraint in
            if constraint.firstAttribute == .width {
                constraint.isActive = false
            }
        }
        
        xpFillView.widthAnchor.constraint(equalTo: xpBarBackground.widthAnchor, multiplier: percentage, constant: -4).isActive = true
        layoutIfNeeded()
    }
}
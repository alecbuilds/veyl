//
//  PixelHealthBar.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

class PixelHealthBar: UIView {
    private let iconView: PixelIcon
    private var segments: [UIView] = []
    private let maxValue: Int = 10
    private var currentValue: Int = 10
    private let barColor: UIColor
    private let statValueLabel = UILabel()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 56) // Fixed size to match the heightAnchor constraint
    }
    
    init(sfSymbol: String, color: UIColor, barType: String) {
        self.iconView = PixelIcon(sfSymbol: sfSymbol, size: 24, color: color)
        self.barColor = color
        super.init(frame: .zero)
        setupHealthBar(color: color, barType: barType)
    }
    
    private func setupHealthBar(color: UIColor, barType: String) {
        // Container with 8-bit styling and rounded corners
        backgroundColor = UIColor(red: 0.067, green: 0.067, blue: 0.133, alpha: 1.0) // #111122
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 0.2, green: 0.2, blue: 0.4, alpha: 1.0).cgColor
        layer.cornerRadius = 8 // Slightly rounded corners
        
        // Force pixelated rendering
        layer.magnificationFilter = .nearest
        layer.minificationFilter = .nearest
        
        // Add inset shadow effect
        addInsetShadow()
        
        // Create horizontal stack with larger spacing
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add type label with fixed width for alignment and larger font
        let label = UILabel()
        label.text = barType.uppercased() + ":"
        label.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        // Set larger fixed width for consistent alignment
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        // Create segments container with equal distribution
        let segmentsContainer = UIStackView()
        segmentsContainer.axis = .horizontal
        segmentsContainer.spacing = 1
        segmentsContainer.alignment = .center
        segmentsContainer.distribution = .fillEqually
        segmentsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Create 10 segments
        for _ in 0..<maxValue {
            let segment = createSegment(color: color)
            segments.append(segment)
            segmentsContainer.addArrangedSubview(segment)
        }
        
        // Set fixed width for segments container to maintain box sizes
        NSLayoutConstraint.activate([
            segmentsContainer.widthAnchor.constraint(equalToConstant: 169) // 16px per segment + 1px spacing * 9 = 169px
        ])
        
        // Setup stat value label (8/10 style)
        setupStatValueLabel()
        
        // Add larger fixed width constraint for icon alignment
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 32),
            iconView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(segmentsContainer)
        stackView.addArrangedSubview(statValueLabel)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            heightAnchor.constraint(equalToConstant: 56)
        ])
        
        updateDisplay()
    }
    
    private func createSegment(color: UIColor) -> UIView {
        let segment = UIView()
        segment.translatesAutoresizingMaskIntoConstraints = false
        
        // Pixelated look
        segment.layer.magnificationFilter = .nearest
        segment.layer.minificationFilter = .nearest
        
        NSLayoutConstraint.activate([
            segment.heightAnchor.constraint(equalToConstant: 16),
            segment.widthAnchor.constraint(equalTo: segment.heightAnchor) // Square aspect ratio
        ])
        
        // Set as filled initially
        setSegmentFilled(segment, color: color, filled: true)
        
        return segment
    }
    
    private func setSegmentFilled(_ segment: UIView, color: UIColor, filled: Bool) {
        if filled {
            segment.backgroundColor = color
            segment.layer.borderWidth = 1
            segment.layer.borderColor = color.darker().cgColor
            
            // Add 3D bevel effect to filled segments
            segment.layer.shadowColor = color.darker(by: 0.5).cgColor
            segment.layer.shadowOffset = CGSize(width: 1, height: 1)
            segment.layer.shadowOpacity = 0.8
            segment.layer.shadowRadius = 0
            
            // Add inner highlight
            addSegmentHighlight(segment)
            
        } else {
            segment.backgroundColor = UIColor(red: 0.133, green: 0.0, blue: 0.0, alpha: 1.0) // Dark empty color
            segment.layer.borderWidth = 1
            segment.layer.borderColor = UIColor(red: 0.267, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
            segment.layer.shadowOpacity = 0
            
            // Remove highlight layers
            segment.layer.sublayers?.removeAll { $0.name == "highlight" }
        }
    }
    
    private func addSegmentHighlight(_ segment: UIView) {
        // Remove existing highlights
        segment.layer.sublayers?.removeAll { $0.name == "highlight" }
        
        let highlightLayer = CALayer()
        highlightLayer.name = "highlight"
        highlightLayer.frame = CGRect(x: 1, y: 1, width: segment.bounds.width-2, height: 1)
        highlightLayer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        segment.layer.addSublayer(highlightLayer)
    }
    
    private func setupStatValueLabel() {
        statValueLabel.text = "\(currentValue)/\(maxValue)"
        statValueLabel.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .bold)
        statValueLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0) // Same as other labels
        statValueLabel.textAlignment = .center
        statValueLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        // Add 8-bit text shadow for authentic look
        statValueLabel.layer.shadowColor = UIColor.black.cgColor
        statValueLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        statValueLabel.layer.shadowOpacity = 1.0
        statValueLabel.layer.shadowRadius = 0
        
        // Fixed width for consistent alignment
        NSLayoutConstraint.activate([
            statValueLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addInsetShadow() {
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 2
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update segment highlights after layout
        for segment in segments {
            if segment.backgroundColor != UIColor(red: 0.133, green: 0.0, blue: 0.0, alpha: 1.0) {
                addSegmentHighlight(segment)
            }
        }
    }
    
    func setValue(_ value: Int, animated: Bool = true) {
        let newValue = max(0, min(maxValue, value))
        
        if animated {
            animateValueChange(from: currentValue, to: newValue)
        } else {
            currentValue = newValue
            updateDisplay()
        }
    }
    
    private func animateValueChange(from oldValue: Int, to newValue: Int) {
        let diff = abs(newValue - oldValue)
        let isIncreasing = newValue > oldValue
        
        for i in 0..<diff {
            let delay = Double(i) * 0.08 // 8-bit timing
            let segmentIndex = isIncreasing ? oldValue + i : oldValue - i - 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if segmentIndex >= 0 && segmentIndex < self.segments.count {
                    let segment = self.segments[segmentIndex]
                    self.setSegmentFilled(segment, color: self.barColor, filled: isIncreasing)
                }
            }
        }
        
        currentValue = newValue
    }
    
    private func updateDisplay() {
        for (index, segment) in segments.enumerated() {
            setSegmentFilled(segment, color: barColor, filled: index < currentValue)
        }
        
        // Update stat value label
        statValueLabel.text = "\(currentValue)/\(maxValue)"
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
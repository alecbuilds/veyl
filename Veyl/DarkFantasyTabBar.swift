//
//  DarkFantasyTabBar.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

protocol DarkFantasyTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: DarkFantasyTabBar, didSelectItemAt index: Int)
}

class DarkFantasyTabBar: UIView {
    
    weak var delegate: DarkFantasyTabBarDelegate?
    
    private let stackView = UIStackView()
    private var tabButtons: [DarkFantasyTabButton] = []
    
    var selectedIndex: Int = 0 {
        didSet {
            updateSelection()
        }
    }
    
    private let tabItems: [(String, UIImage?)] = [
        ("HOME", nil),
        ("QUESTS", nil),
        ("STATS", nil),
        ("PROFILE", nil)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Transparent background - no container visible
        backgroundColor = UIColor.clear
        

        
        setupStackView()
        setupTabButtons()
    }
    
    private func setupStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    private func setupTabButtons() {
        for (index, item) in tabItems.enumerated() {
            let button = DarkFantasyTabButton(title: item.0, icon: item.1)
            button.tag = index
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
            
            tabButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        // Set initial selection
        updateSelection()
    }
    
    @objc private func tabButtonTapped(_ sender: DarkFantasyTabButton) {
        let index = sender.tag
        delegate?.tabBar(self, didSelectItemAt: index)
    }
    
    private func updateSelection() {
        for (index, button) in tabButtons.enumerated() {
            button.isSelected = (index == selectedIndex)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
//
//  VeylTabBarController.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit
import SwiftUI

class VeylTabBarController: UITabBarController {
    
    private let customTabBar = DarkFantasyTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomTabBar()
        setupViewControllers()
    }
    
    private func setupCustomTabBar() {
        // Hide the default tab bar
        tabBar.isHidden = true
        
        // Add custom tab bar
        customTabBar.delegate = self
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        
        // Pin to bottom with safe area
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // Set initial selection
        customTabBar.selectedIndex = 0
    }
    
    private func setupViewControllers() {
        // Home tab - functional with your existing HomeView
        let homeVC = UIHostingController(rootView: HomeView())
        homeVC.view.backgroundColor = .black
        homeVC.title = "Home"
        
        // Non-functional placeholder tabs
        let questsVC = PlaceholderViewController(title: "QUESTS", message: "Coming Soon...")
        let statsVC = PlaceholderViewController(title: "STATS", message: "Coming Soon...")
        let profileVC = PlaceholderViewController(title: "PROFILE", message: "Coming Soon...")
        
        viewControllers = [homeVC, questsVC, statsVC, profileVC]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Adjust content insets for all view controllers
        if let selectedVC = selectedViewController {
            selectedVC.additionalSafeAreaInsets.bottom = 70
        }
    }
}

// MARK: - DarkFantasyTabBarDelegate
extension VeylTabBarController: DarkFantasyTabBarDelegate {
    func tabBar(_ tabBar: DarkFantasyTabBar, didSelectItemAt index: Int) {
        // Only allow home tab (index 0) to be functional
        if index == 0 {
            selectedIndex = index
            viewDidLayoutSubviews()
        } else {
            // Visual feedback but no navigation
            tabBar.selectedIndex = 0 // Keep home selected
        }
    }
}

// MARK: - Placeholder View Controller for non-functional tabs
class PlaceholderViewController: UIViewController {
    
    private let titleText: String
    private let messageText: String
    
    init(title: String, message: String) {
        self.titleText = title
        self.messageText = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.33, green: 0.33, blue: 0.8, alpha: 1.0)
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        messageLabel.text = messageText
        messageLabel.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .medium)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(messageLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
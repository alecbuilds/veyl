//
//  TabBarWrapperView.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI
import UIKit

struct TabBarWrapperView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> VeylTabBarController {
        return VeylTabBarController()
    }
    
    func updateUIViewController(_ uiViewController: VeylTabBarController, context: Context) {
        // No updates needed for this implementation
    }
}

struct TabBarWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarWrapperView()
            .ignoresSafeArea()
    }
}
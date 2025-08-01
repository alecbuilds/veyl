//
//  HomeView.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI

struct HomeView: View {
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
            

        }
    }
}

#Preview {
    HomeView()
}
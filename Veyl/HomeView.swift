//
//  HomeView.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import SwiftUI
import SpriteKit

struct HomeView: View {
    var body: some View {
        ZStack {
            // Pure black background
            Color.black
                .ignoresSafeArea(.all)
            
            // SpriteKit scene with ember effects
            HeroSceneView()
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
            
            // 8-bit health bars centered on screen
            HealthBarSystem()
                .fixedSize()
                .allowsHitTesting(false)
        }
    }
}



#Preview {
    HomeView()
}
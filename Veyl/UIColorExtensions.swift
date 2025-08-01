//
//  UIColorExtensions.swift
//  Veyl
//
//  Created by Alec Smith on 7/31/25.
//

import UIKit

extension UIColor {
    func darker(by percentage: CGFloat = 0.3) -> UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * (1.0 - percentage), alpha: alpha)
    }
    
    // 8-bit color palette
    static let pixel8BitRed = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    static let pixel8BitOrange = UIColor(red: 1.0, green: 0.67, blue: 0.0, alpha: 1.0)
    static let pixel8BitPurple = UIColor(red: 0.67, green: 0.27, blue: 0.67, alpha: 1.0)
    static let pixel8BitBlue = UIColor(red: 0.0, green: 0.4, blue: 1.0, alpha: 1.0)
    static let pixel8BitYellow = UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
    static let pixel8BitCyan = UIColor(red: 0.0, green: 0.8, blue: 0.8, alpha: 1.0)
}
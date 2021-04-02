//
//  Color+Extension.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static let vividOrange = Color(hex: "ff9900")
    static let christmasYellow = Color(hex: "ffcc00")
    static let deepPurple = Color(hex: "663399")
    static let calmBlue = Color(hex: "336699")
    static let vividGreen = Color(hex: "009900")
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}


//
//  TabBarShape.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct TabBarShape: Shape {
    var tappedItemMidX: CGFloat
    var animatableData: CGFloat {
        get { tappedItemMidX }
        set { tappedItemMidX = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
            
            path.move(to: CGPoint(x: tappedItemMidX - 44, y: 0))
            
            let to1 = CGPoint(x: tappedItemMidX, y: 25)
            let ctrl1a = CGPoint(x: tappedItemMidX - 22, y: 0)
            let ctrl1b = CGPoint(x: tappedItemMidX - 22, y: 25)
            path.addCurve(to: to1, control1: ctrl1a, control2: ctrl1b)
            
            let to2 = CGPoint(x: tappedItemMidX + 44, y: 0)
            let ctrl2a = CGPoint(x: tappedItemMidX + 22, y: 25)
            let ctrl2b = CGPoint(x: tappedItemMidX + 22, y: 0)
            path.addCurve(to: to2, control1: ctrl2a, control2: ctrl2b)
        }
    }
}

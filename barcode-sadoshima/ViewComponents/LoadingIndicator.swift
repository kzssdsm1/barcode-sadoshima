//
//  LoadingIndicator.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/03.
//

import SwiftUI

struct LoadingIndicator: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.6)
                .frame(width: 100, height: 100)
                .cornerRadius(12)
            
            Circle()
                .trim(from: 0, to: 0.6)
                .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round,
                            dash: [0.1, 16],
                            dashPhase: 8))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .onAppear() {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
                .onDisappear() {
                    isAnimating = false
                }
        } // ZStack
        .drawingGroup()
    } // body
}

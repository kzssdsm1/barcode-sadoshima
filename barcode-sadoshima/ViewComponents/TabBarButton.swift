//
//  TabBarButton.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct TabBarButton: View {
    let imageName: String
    let buttonColor: Color
    let proxy: GeometryProxy
    
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundColor(buttonColor)
            .rotationEffect(.degrees(buttonColor == .gray ? 0 : 360))
            .padding(buttonColor == .gray ? 5 : 10)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(
                color: buttonColor == .gray ? .clear : .gray,
                radius: 1, x: 0, y: 4
            )
            .offset(y: buttonColor == .gray ? -10 : -40)
    } // body
}

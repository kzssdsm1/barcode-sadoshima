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
            .frame(width: 25, height: 25)
            .foregroundColor(buttonColor)
            .padding(5)
            .offset(y: -10)
    } // body
}

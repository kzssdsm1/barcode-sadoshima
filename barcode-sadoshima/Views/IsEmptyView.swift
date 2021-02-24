//
//  IsEmptyView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/25.
//

import SwiftUI

struct IsEmptyView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                
                Text("カメラは一時的に停止されています")
                    .foregroundColor(.black)
                    .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        background(Color.white.ignoresSafeArea(.all, edges: .all))
    }
}

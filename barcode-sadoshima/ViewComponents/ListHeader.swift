//
//  ListHeader.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI

struct ListHeader: View {
    @Binding var isEditMode: Bool
    @Binding var removeItemString: [String]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text("お気に入りリスト")
                    .foregroundColor(.black)
                    .font(.system(size: CGFloat(geometry.size.height * 0.35), weight: .heavy))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    if (isEditMode) {
                        removeItemString = []
                    }
                    isEditMode.toggle()
                }) {
                    Text((isEditMode) ? "終了" : "編集")
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(geometry.size.height * 0.35), weight: .medium))
                }
            }
        }
    }
}

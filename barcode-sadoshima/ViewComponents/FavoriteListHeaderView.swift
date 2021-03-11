//
//  FavoriteListHeaderView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/11.
//

import SwiftUI

struct FavoriteListHeaderView: View {
    @Binding var isEditing: Bool
    @Binding var removeItems: [String]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Text("お気に入りリスト")
                    .font(.system(size: CGFloat(geometry.size.height * 0.35), weight: .heavy))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    if (isEditing) {
                        removeItems = []
                    }
                    isEditing.toggle()
                }) {
                    Text((isEditing) ? "終了" : "編集")
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(geometry.size.height * 0.35), weight: .medium))
                }
            }
            .padding(CGFloat(geometry.size.height * 0.15))
        }
    }
}

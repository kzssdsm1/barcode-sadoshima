//
//  SortButtonBarView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/05.
//

import SwiftUI

// MARK: - 並び替えボタンを配置しているバーの構造体
struct SortButtonBarView: View {
    @Binding var isAscending: Bool
    @Binding var sortKeyPath: ReferenceWritableKeyPath<FavoriteItem, String>
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                
                Text("並び順：")
                    .foregroundColor(.blue)
                    .font(.system(size: (geometry.size.height * 0.55), weight: .heavy))
                    .padding(.trailing, (geometry.size.width * 0.02))
                
                Menu {
                    Button("↓日時", action: {
                        isAscending = false
                        sortKeyPath = \FavoriteItem.date
                    })
                    Button("↑日時", action: {
                        isAscending = true
                        sortKeyPath = \FavoriteItem.date
                    })
                    Button("↓名前", action: {
                        isAscending = false
                        sortKeyPath = \FavoriteItem.title
                    })
                    Button("↑名前", action: {
                        isAscending = true
                        sortKeyPath = \FavoriteItem.title
                    })
                } label: {
                    Label(
                        (sortKeyPath == \FavoriteItem.date) ? "日時" : "名前",
                        systemImage: (isAscending == true) ? "arrow.up" : "arrow.down"
                    )
                    .font(.system(size: (geometry.size.height * 0.6), weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: (geometry.size.width * 0.19), height:(geometry.size.height))
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                
                Spacer(minLength: 0)
            } // HStack
        } // GeometryReader
    } // body
}

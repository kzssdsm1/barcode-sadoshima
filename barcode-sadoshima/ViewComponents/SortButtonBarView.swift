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
    
    @State private var currentSortingMethod = "日時↓"
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                
                Text("並び順：")
                    .foregroundColor(.blue)
                    .font(.system(size: (geometry.size.height * 0.55), weight: .heavy))
                    .padding(.trailing, (geometry.size.width * 0.05))
                
                Menu(currentSortingMethod) {
                    Button("日時↓", action: {
                        isAscending = false
                        sortKeyPath = \FavoriteItem.date
                        currentSortingMethod = "日時↓"
                    })
                    Button("日時↑", action: {
                        isAscending = true
                        sortKeyPath = \FavoriteItem.date
                        currentSortingMethod = "日時↑"
                    })
                    Button("名前↓", action: {
                        isAscending = false
                        sortKeyPath = \FavoriteItem.title
                        currentSortingMethod = "名前↓"
                    })
                    Button("名前↑", action: {
                        isAscending = true
                        sortKeyPath = \FavoriteItem.title
                        currentSortingMethod = "名前↑"
                    })
                }
                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.7)
                
                Spacer(minLength: 0)
            } // HStack
        } // GeometryReader
    } // body
}

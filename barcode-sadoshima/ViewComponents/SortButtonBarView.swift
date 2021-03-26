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
                    .font(.system(size: (geometry.size.height * 0.5), weight: .heavy))
                    .padding(.trailing, (geometry.size.width * 0.05))
                
                Button(action: {
                    if (sortKeyPath == \FavoriteItem.date) {
                        if (isAscending) {
                            isAscending = false
                        } else {
                            isAscending = true
                        }
                    } else {
                        sortKeyPath = \FavoriteItem.date
                        isAscending = false
                    }
                    
                }) {
                    if (sortKeyPath == \FavoriteItem.title) {
                        Text("日時")
                            .foregroundColor(.blue)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                    } else {
                        Text((isAscending) ? "日時↑" : "日時↓")
                            .foregroundColor(.white)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                            .frame(width: (geometry.size.width * 0.2), height:(geometry.size.height * 0.85))
                            .background(Color.blue)
                            .cornerRadius(6)
                    }
                }
                .padding(.trailing, (sortKeyPath == \FavoriteItem.title) ? (geometry.size.width * 0.105) : (geometry.size.width * 0.1))
                
                Button(action: {
                    if (sortKeyPath == \FavoriteItem.title) {
                        if (isAscending) {
                            isAscending = false
                        } else {
                            isAscending = true
                        }
                    } else {
                        sortKeyPath = \FavoriteItem.title
                        isAscending = false
                    }
                }) {
                    if (sortKeyPath == \FavoriteItem.date) {
                        Text("タイトル")
                            .foregroundColor(.blue)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                    } else {
                        Text((isAscending) ? "タイトル↑" : "タイトル↓")
                            .foregroundColor(.white)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                            .frame(width: (geometry.size.width * 0.3), height:(geometry.size.height * 0.85))
                            .background(Color.blue)
                            .cornerRadius(6)
                        
                    }
                }
                
                Spacer(minLength: 0)
            } // HStack
        } // GeometryReader
    } // body
}

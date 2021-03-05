//
//  SortButtonBarView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/05.
//

import SwiftUI

struct SortButtonBarView: View {
    @Binding var isAscending: Bool
    @Binding var sortPath: ReferenceWritableKeyPath<FavoriteItem, String>
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                
                Button(action: {
                    if (sortPath == \FavoriteItem.date) {
                        if (isAscending) {
                            isAscending = false
                        } else {
                            isAscending = true
                        }
                    } else {
                        sortPath = \FavoriteItem.date
                        isAscending = false
                    }
                    
                }) {
                    if (sortPath == \FavoriteItem.title) {
                        Text("日時")
                            .foregroundColor(.blue)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                    } else {
                        if (isAscending) {
                            Text("日時↓")
                                .foregroundColor(.blue)
                                .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                        } else {
                            Text("日時↑")
                                .foregroundColor(.blue)
                                .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                        }
                    }
                }
                .padding(.trailing, (geometry.size.width * 0.1))
                
                Button(action: {
                    if (sortPath == \FavoriteItem.title) {
                        if (isAscending) {
                            isAscending = false
                        } else {
                            isAscending = true
                        }
                    } else {
                        sortPath = \FavoriteItem.title
                        isAscending = false
                    }
                }) {
                    if (sortPath == \FavoriteItem.date) {
                        Text("タイトル")
                            .foregroundColor(.blue)
                            .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                    } else {
                        if (isAscending) {
                            Text("タイトル↓")
                                .foregroundColor(.blue)
                                .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                        } else {
                            Text("タイトル↑")
                                .foregroundColor(.blue)
                                .font(.system(size: (geometry.size.height * 0.7), weight: .heavy))
                        }
                    }
                }
                
                Spacer(minLength: 0)
            } // HStack
        } // GeometryReader
    }
}

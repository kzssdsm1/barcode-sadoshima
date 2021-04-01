//
//  FavoriteListViewHeader.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct FavoriteListViewHeader: View {
    @Binding var isEditing: Bool
    @Binding var removeItems: [String]
    @Binding var isEmpty: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text("お気に入りリスト")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.gray)
            
            Spacer(minLength: 0)
            
            if !isEditing {
                Button(action: {
                    withAnimation {
                        removeItems = []
                        isEditing = true
                    }
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .overlay(
                            Image(systemName: "folder.fill.badge.gear")
                                .foregroundColor(isEmpty ? .gray : .accentColor)
                                .offset(y: -5)
                        )
                        .background(
                            Text(isEditing ? "終了" : "編集")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(isEmpty ? .gray : .accentColor)
                                .offset(y: 12)
                        )
                }
                .buttonStyle(CustomButtonStyle())
                .frame(width: 50, height: 50)
                .disabled(isEmpty)
                .padding(.trailing, 10)
            } else {
                Button(action: {
                    withAnimation {
                        isEditing = false
                    }
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .overlay(
                            Image(systemName: "xmark.octagon.fill")
                                .foregroundColor(.accentColor)
                                .offset(y: -5)
                        )
                        .background(
                            Text("終了")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.accentColor)
                                .offset(y: 12)
                        )
                }
                .buttonStyle(CustomButtonStyle())
                .frame(width: 50, height: 50)
                .disabled(!isEditing)
                .padding(.trailing, 10)
            }
        } // HStack
        .padding(10)
        .frame(height: 60)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
    } // body
}


//
//  EditButtonBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct EditButtonBar: View {
    @Binding var isShowingAlert: Bool
    @Binding var removeItems: [String]
    
    let items: [FavoriteItem]
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                removeItems = []
                for item in items {
                    removeItems.append(item.link)
                }
            }) {
                Text("全てを選択")
                    .foregroundColor(items.isEmpty || items.count == removeItems.count ? .gray : .accentColor)
                    .font(.system(size: 14, weight: .medium))
            }
            .disabled(items.isEmpty || items.count == removeItems.count)
            .padding(.trailing, 10)
            
            Button(action: {
                removeItems = []
            }) {
                Text("全てを解除")
                    .foregroundColor((items.isEmpty || removeItems.isEmpty) ? .gray : .accentColor)
                    .font(.system(size: 14, weight: .medium))
                    .padding(.leading, 10)
            }
            .disabled(removeItems.isEmpty || items.isEmpty)
            
            Spacer(minLength: 0)
            
            Button(action: {
                isShowingAlert = true
            }) {
                Text("削除")
                    .foregroundColor(items.isEmpty || removeItems.isEmpty ? .gray : .accentColor)
                    .font(.system(size: 14, weight: .medium))
            }
            .disabled(removeItems.isEmpty || items.isEmpty)
        }
        .padding(.horizontal ,30)
        .frame(height: 50)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.offWhite)
                .frame(width: screenWidth - 30, height: 50)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        )
        .padding(.vertical, 10)
    }
}

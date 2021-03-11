//
//  EditButtonBarView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/11.
//

import SwiftUI
import CoreData

struct EditButtonBarView: View {
    @Binding var removeItems: [String]
    @Binding var isShowAlert: Bool

    let items: [FavoriteItem]
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    removeItems = []
                }) {
                    Text("全てを解除")
                        .foregroundColor((items.isEmpty || removeItems.isEmpty) ? .gray : .blue)
                        .opacity((items.isEmpty || removeItems.isEmpty) ? 0.6 : 1)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                        .padding(.trailing, CGFloat(geometry.size.height * 0.05))
                }
                .disabled(items.isEmpty || removeItems.isEmpty)

                Button(action: {
                    removeItems = []
                    for item in items {
                        removeItems.append(item.link)
                    }
                }) {
                    Text("全てを選択")
                        .foregroundColor((items.isEmpty) ? .gray : .blue)
                        .opacity((items.isEmpty) ? 0.6 : 1)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                }
                .disabled(items.isEmpty)

                Spacer(minLength: 0)

                Button(action: {
                    isShowAlert = true
                }) {
                    Text("削除")
                        .foregroundColor((items.isEmpty || removeItems.isEmpty) ? .gray : .blue)
                        .opacity((items.isEmpty || removeItems.isEmpty) ? 0.6 : 1)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                }
                .disabled(removeItems.isEmpty || items.isEmpty)
            }
        }
    }
}

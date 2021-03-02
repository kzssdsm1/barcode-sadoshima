//
//  EditBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI
import CoreData

struct EditBar: View {
    @Binding var removeItemNum: [Int]
    @Binding var isShowRemove: Bool

    @FetchRequest(entity: FavoriteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.date, ascending: false)],animation: nil) private var items : FetchedResults<FavoriteItem>
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    removeItemNum = []
                }) {
                    Text("全てを解除")
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                        .padding(.trailing, CGFloat(geometry.size.height * 0.05))
                }
                .disabled(items.isEmpty)

                Button(action: {
                    removeItemNum = []
                    for count in 0..<items.count {
                        removeItemNum.append(count)
                    }
                }) {
                    Text("全てを選択")
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                }
                .disabled(items.isEmpty)

                Spacer(minLength: 0)

                Button(action: {
                    isShowRemove = true
                }) {
                    Text("削除")
                        .foregroundColor(.blue)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                }
                .disabled(removeItemNum.isEmpty || items.isEmpty)
            }
        }
    }
}

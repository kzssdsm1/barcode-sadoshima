//
//  EditBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI
import CoreData

// MARK: - 編集モードの際に使用できる編集バーの構造体
struct EditBar: View {
    @Binding var removeItemString: [String]
    @Binding var isShowRemove: Bool

    @FetchRequest var items: FetchedResults<FavoriteItem>
    
    init(removeItemString: Binding<[String]>, isShowRemove: Binding<Bool>, items: FetchRequest<FavoriteItem>) {
        self._removeItemString = removeItemString
        self._isShowRemove = isShowRemove
        self._items = items
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    removeItemString = []
                }) {
                    Text("全てを解除")
                        .foregroundColor((items.isEmpty || removeItemString.isEmpty) ? .gray : .blue)
                        .opacity((items.isEmpty || removeItemString.isEmpty) ? 0.6 : 1)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                        .padding(.trailing, CGFloat(geometry.size.height * 0.05))
                }
                .disabled(items.isEmpty || removeItemString.isEmpty)

                Button(action: {
                    removeItemString = []
                    for item in items {
                        removeItemString.append(item.link)
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
                    isShowRemove = true
                }) {
                    Text("削除")
                        .foregroundColor((items.isEmpty || removeItemString.isEmpty) ? .gray : .blue)
                        .opacity((items.isEmpty || removeItemString.isEmpty) ? 0.6 : 1)
                        .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                }
                .disabled(removeItemString.isEmpty || items.isEmpty)
            }
        }
    }
}

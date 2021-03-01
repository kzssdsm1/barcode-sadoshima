//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct FavoriteListView: View {
    @Binding var item: Item?
    
    @FetchRequest(entity: FavoriteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.date, ascending: false)],animation: .spring()) private var items : FetchedResults<FavoriteItem>
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if (items.isEmpty) {
                    Spacer()
                    
                    Text("お気に入りリストに登録された商品がありません")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                    
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(items) { item in
                                Button(action: {
                                    self.item = convertToItem(item: item)
                                }) {
                                    CardView(input: convertToItem(item: item))
                                        .frame(width: (geometry.size.width - 30))
                                        .frame(minHeight: (geometry.size.height * 0.4))
                                        .padding(EdgeInsets(
                                                    // 上部のバーと被らないようにするため1だけpaddingを設定する
                                                    top: 1,
                                                    leading: (geometry.size.height * 0.05),
                                                    bottom: (item.title.count > 21) ? (geometry.size.height * buildCGFloat(item.title.count)) : (geometry.size.height * 0.17),
                                                    trailing: (geometry.size.height * 0.05))
                                        )
                                } // Button
                            } // ForEach
                        } // LazyVStack
                    } // ScrollView
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        } // GeometryReader
    } // body
    
    private func buildCGFloat(_ titleCount: Int) -> CGFloat {
        let count = titleCount / 21 - 1
        let double = Double(count) * 0.03 + 0.2
        let cgFloat = CGFloat(double)
        return cgFloat
    }
    
    private func convertToItem(item: FavoriteItem) -> Item {
        return Item(
            author: item.author,
            date: item.date,
            image: item.image,
            link: item.link,
            price: item.price,
            title: item.title
        )
    }
}

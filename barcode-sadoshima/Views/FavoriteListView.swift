//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct FavoriteListView: View {
    @Binding var item: Item?
    
    @FetchRequest(entity: FavoriteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.date, ascending: true)],animation: .spring()) private var items : FetchedResults<FavoriteItem>
    
    var body: some View {
        GeometryReader { geometry in
            if !(items.isEmpty) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .center) {
                            ForEach(items) { item in
                                Button(action: {
                                    self.item = convertToItem(item: item)
                                }) {
                                    CardView(input: convertToItem(item: item))
                                        .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.25)
                                        .padding()
                                } // Button
                            } // ForEach

                    } // LazyVStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } // ScrollView
                .background(Color.white.ignoresSafeArea(.all, edges: .all))
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("お気に入りリストに登録された商品がありません")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                    
                    Spacer()
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea(.all, edges: .all))
            }
        }
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

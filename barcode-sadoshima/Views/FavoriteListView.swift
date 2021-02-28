//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct FavoriteListView: View {
    @Environment(\.managedObjectContext) var context
    
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
                    
//                    Button(action: {
//                        let test = Item(author: "誉田哲也",
//                                        date: "TEST",
//                                        image: "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/7456/9784334777456.jpg?_ex=200x200",
//                                        link: "https://books.rakuten.co.jp/rb/15696282/",
//                                        price: "836",
//                                        title: "硝子の太陽")
//                        addItem(item: test)
//                    }) {
//                        Text("お気に入りリストに登録された商品がありません")
//                            .foregroundColor(.black)
//                            .font(.system(size: geometry.size.height * 0.03, weight: .medium))
//                    } // Button
                    
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
    
//    func addItem(item: Item) {
//        let newItem = FavoriteItem(context: context)
//        
//        newItem.author = item.author
//        newItem.date = item.date
//        newItem.image = item.image
//        newItem.link = item.link
//        newItem.price = item.price
//        newItem.title = item.title
//        
//        guard context.hasChanges else {
//            return
//        }
//        
//        do {
//            try context.save()
//        } catch {
//            fatalError()
//        }
//    }
}

//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct FavoriteListView: View {
    @Binding var item: Item?
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(entity: FavoriteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.date, ascending: false)],animation: .spring()) private var items : FetchedResults<FavoriteItem>
    
    @StateObject private var viewModel = FavoriteListViewModel()
    
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
                            ForEach(0 ..< items.count, id: \.self) { index in
                                let item = items[index]
                                VStack(alignment: .leading, spacing: 0) {
                                    Button(action: {
                                        viewModel.removeItemNum.append(index)
                                        viewModel.isShowAlert = true
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .renderingMode(.original)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 35, height: 35)
                                            .padding(EdgeInsets(
                                                        top: (geometry.size.height * 0.03),
                                                        leading: (geometry.size.height * 0.077),
                                                        bottom: 0,
                                                        trailing: 0)
                                            )
                                    }
                                    
                                    Button(action: {
                                        self.item = convertToItem(item: item)
                                    }) {
                                        CardView(input: convertToItem(item: item))
                                            .frame(width: (geometry.size.width - 30))
                                            .frame(minHeight: (geometry.size.height * 0.3))
                                    }
                                }
                                .frame(width: (geometry.size.width - 30))
                                .frame(minHeight: (geometry.size.height * 0.65))
                                .frame(maxHeight: .infinity)
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                                .padding(EdgeInsets(
                                            // 上部のバーと被らないようにするため1だけpaddingを設定する
                                            top: 1,
                                            leading: (geometry.size.height * 0.05),
                                            bottom: (item.title.count > 21) ? (geometry.size.height * buildCGFloat(item.title.count)) : (geometry.size.height * 0.06),
                                            trailing: (geometry.size.height * 0.05))
                                )
                            } // ForEach
                        } // LazyVStack
                    } // ScrollView
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        } // GeometryReader
        .onAppear {
            viewModel.setData(context: context)
        }
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(
                title: Text("削除"),
                message: Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")) {
                    viewModel.removeItemNum = []
                },
                secondaryButton: .destructive(Text("削除")) {
                    viewModel.removeItem()
                })
        } // .alert
    } // body
    
    private func buildCGFloat(_ titleCount: Int) -> CGFloat {
        let count = titleCount / 21 - 1
        let double = Double(count) * 0.03 + 0.06
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

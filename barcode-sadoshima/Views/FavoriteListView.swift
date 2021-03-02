//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

// 式が複雑すぎてコンパイルが通らなかったため削除ボタンと上部の編集バーを部品化して別のファイルに分けています
// 各所のCGFloatは型チェックを突破しようと試みた時の名残です

struct FavoriteListView: View {
    @Binding var item: Item?
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(entity: FavoriteItem.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \FavoriteItem.date, ascending: false)],animation: .spring()) private var items : FetchedResults<FavoriteItem>
    
    @State private var removeItemNum: [Int] = []
    @State private var isShowRemove: Bool = false
    @State private var isEditMode: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text("お気に入りリスト")
                        .foregroundColor(.black)
                        .font(.system(size: CGFloat(geometry.size.height * 0.03), weight: .heavy))
                        .padding(CGFloat(geometry.size.height * 0.02))
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        if (isEditMode) {
                            removeItemNum = []
                        }
                        isEditMode.toggle()
                    }) {
                        Text((isEditMode) ? "終了" : "編集")
                            .foregroundColor(.blue)
                            .font(.system(size: CGFloat(geometry.size.height * 0.025), weight: .medium))
                            .padding(CGFloat(geometry.size.height * 0.02))
                    }
                }
                if (isEditMode) {
                    EditBar(removeItemNum: $removeItemNum, isShowRemove: $isShowRemove)
                        .frame(height: CGFloat(geometry.size.height * 0.05))
                        .padding([.top, .horizontal], CGFloat(geometry.size.height * 0.02))
                }
                if (items.isEmpty) {
                    Spacer()
                    
                    Text("お気に入りリストに登録された商品がありません")
                        .foregroundColor(.black)
                        .font(.system(size: CGFloat(geometry.size.height * 0.03), weight: .medium))
                    
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(0 ..< items.count, id: \.self) { index in
                                let item: FavoriteItem = items[index]
                                VStack(alignment: .leading, spacing: 0) {
                                    TrashButton(removeItemNum: $removeItemNum, isEditMode: $isEditMode, isShowRemove: $isShowRemove, index: index)
                                        .padding(EdgeInsets(
                                                    top: CGFloat(geometry.size.height * 0.03),
                                                    leading: CGFloat(geometry.size.height * 0.06),
                                                    bottom: 0,
                                                    trailing: 0)
                                        )
                                    
                                    Button(action: {
                                        if (isEditMode) {
                                            if let itemIndex = removeItemNum.firstIndex(where: {$0 == index}) {
                                                removeItemNum.remove(at: itemIndex)
                                            } else {
                                                removeItemNum.append(index)
                                            }
                                        } else {
                                            self.item = convertToItem(item: item)
                                        }
                                    }) {
                                        CardView(input: convertToItem(item: item))
                                            .frame(width: CGFloat(geometry.size.width - 30))
                                            .frame(minHeight: CGFloat(geometry.size.height * 0.3))
                                    }
                                }
                                .frame(width: CGFloat(geometry.size.width - 30))
                                .frame(minHeight: CGFloat(geometry.size.height * 0.65))
                                .frame(maxHeight: .infinity)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke((removeItemNum.firstIndex(where: {$0 == index}) != nil) ?  Color.blue : Color.gray, lineWidth: 1))
                                .padding(EdgeInsets(
                                            // 上部のバーと被らないようにするため1だけpaddingを設定する
                                            top: 1,
                                            leading: CGFloat(geometry.size.height * 0.05),
                                            bottom: (item.title.count > 21) ? CGFloat(geometry.size.height * buildCGFloat(item.title.count)) : CGFloat(geometry.size.height * 0.06),
                                            trailing: CGFloat(geometry.size.height * 0.05))
                                )
                            } // ForEach
                        } // LazyVStack
                    } // ScrollView
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        } // GeometryReader
        .alert(isPresented: $isShowRemove) {
            Alert(
                title: Text("削除"),
                message: (isEditMode) ? Text("選択した商品を削除しますか？") : Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")) {
                    removeItemNum = []
                },
                secondaryButton: .destructive(Text("削除")) {
                    removeItem()
                })
        } // .alert
    } // body
    
    private func buildCGFloat(_ titleCount: Int) -> CGFloat {
        let count: Int = titleCount / 21 - 1
        let double: Double = Double(count) * 0.03 + 0.06
        let cgFloat: CGFloat = CGFloat(double)
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
    
    private func removeItem() {
        removeItemNum.forEach { index in
            context.delete(items[index])
        }
        
        do {
            try context.save()
            removeItemNum = []
        } catch {
            fatalError()
        }
    }
}

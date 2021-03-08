//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI
import CoreData

/// お気に入りリストの構造体
struct FavoriteListView: View {
    @State private var item: Item?
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest var items: FetchedResults<FavoriteItem>
    
    @State private var removeItemString: [String] = []
    @State private var isShowRemove: Bool = false
    @State private var isEditMode: Bool = false
    @State private var isKeyboardShow = false
    
    let inputText: String
    let isAscending: Bool
    let sortPath: ReferenceWritableKeyPath<FavoriteItem, String>
    
    init(inputText: String, isAscending: Bool, sortPath: ReferenceWritableKeyPath<FavoriteItem, String>) {
        self.inputText = inputText
        self.isAscending = isAscending
        self.sortPath = sortPath
        
        if self.inputText != "" {
            self._items = FetchRequest(
                entity: FavoriteItem.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: sortPath, ascending: isAscending)],
                predicate: NSPredicate(format: "title CONTAINS[C] %@", inputText),
                animation: .spring()
            )
        } else {
            self._items = FetchRequest(
                entity: FavoriteItem.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: sortPath, ascending: isAscending)],
                animation: .spring()
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if !(isKeyboardShow) {
                    ListHeader(isEditMode: $isEditMode, removeItemString: $removeItemString)
                        .frame(height: CGFloat(geometry.size.height * 0.08))
                        .padding([.top, .horizontal], CGFloat(geometry.size.height * 0.02))
                    
                }
                
                if (isEditMode) {
                    EditBar(removeItemString: $removeItemString, isShowRemove: $isShowRemove, items: _items)
                        .frame(height: CGFloat(geometry.size.height * 0.05))
                        .padding([.horizontal], CGFloat(geometry.size.height * 0.02))
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
                                    TrashButton(removeItemString: $removeItemString, isEditMode: $isEditMode, isShowRemove: $isShowRemove, index: item.link)
                                        .padding(EdgeInsets(
                                                    top: CGFloat(geometry.size.height * 0.03),
                                                    leading: CGFloat(geometry.size.height * 0.06),
                                                    bottom: 0,
                                                    trailing: 0)
                                        )
                                    
                                    Button(action: {
                                        if (isEditMode) {
                                            if let itemIndex = removeItemString.firstIndex(where: {$0 == item.link}) {
                                                removeItemString.remove(at: itemIndex)
                                            } else {
                                                removeItemString.append(item.link)
                                            }
                                        } else {
                                            self.item = convertToItem(item: item)
                                        }
                                    }) {
                                        CardView(input: convertToItem(item: item))
                                            .frame(width: CGFloat(geometry.size.width - 30))
                                            .frame(minHeight: CGFloat(geometry.size.height * 0.3))
                                            .frame(maxHeight: .infinity)
                                    }
                                } // VStack
                                .frame(width: CGFloat(geometry.size.width - 30))
                                .frame(minHeight: CGFloat(geometry.size.height * 0.65))
                                .frame(maxHeight: .infinity)
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke((removeItemString.firstIndex(where: {$0 == item.link}) != nil) ?  Color.blue : Color.gray, lineWidth: 1))
                                .padding(EdgeInsets(
                                            // ヘッダーと被らないようにするため上部に1だけpaddingを設定する
                                            // ヘッダーが隠れている時はレイアウトがつまっている印象を避けるため余白を設定する
                                            top: (isKeyboardShow) ? CGFloat(geometry.size.height * 0.05) : 1,
                                            leading: CGFloat(geometry.size.height * 0.05),
                                            // 書籍のタイトルがCardViewのサイズでスケールする一方、CradViewの外部に設定している余白は
                                            // 本Viewのサイズによってスケールするためタイトルの行数によっては垂直方向のレイアウトが崩れる
                                            // それを避けるためにタイトルの改行を検知して適宜下方の余白を再設定する
                                            bottom: (item.title.count > 21) ? CGFloat(geometry.size.height * buildCGFloat(item.title.count)) : CGFloat(geometry.size.height * 0.06),
                                            trailing: CGFloat(geometry.size.height * 0.05))
                                )
                            } // ForEach
                        } // LazyVStack
                    } // ScrollView
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        } // GeometryReader
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            self.isKeyboardShow = true
        }.onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            self.isKeyboardShow = false
        }
        .alert(isPresented: $isShowRemove) {
            Alert(
                title: Text("削除"),
                message: (isEditMode) ? Text("選択した商品を削除しますか？") : Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")) {
                    removeItemString = []
                },
                secondaryButton: .destructive(Text("削除")) {
                    removeItem()
                })
        } // .alert
        .sheet(item: $item) { item in
            ItemView(input: item, title: "詳細")
        } // .sheet
    } // body
    
    /// 書籍タイトルの文字数を受け取り適切な下方paddigの値を返す関数（1行は21文字）
    /// - Parameter titleCount: 書籍タイトルの文字数
    /// - Returns: 下方paddingの値
    private func buildCGFloat(_ titleCount: Int) -> CGFloat {
        let count: Int = titleCount / 21 - 1
        let double: Double = Double(count) * 0.03 + 0.06
        let cgFloat: CGFloat = CGFloat(double)
        return cgFloat
    }
    
    /// CardViewに渡すためFavoriteItemの構造体をItem構造体に変換する関数
    /// - Parameter item: FavoriteItemの構造体
    /// - Returns: Itemの構造体
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
    
    /// 選択された書籍を削除するメソッド
    private func removeItem() {
        removeItemString.forEach { link in
            // 削除する書籍は商品掲載URLを用いて同定する
            guard let item = searchItem(link) else {
                return
            }
            // データの重複登録はされないようになっているため常に配列の一番の最初の値を取り出す
            context.delete(item[0])
        }
        
        do {
            try context.save()
            removeItemString = []
        } catch {
            fatalError()
        }
    }
    
    /// 削除する書籍をCoreDataから検索する関数
    /// - Parameter link: 削除する書籍の商品掲載URL
    /// - Returns: 削除する書籍が格納された配列
    private func searchItem(_ link: String) -> [FavoriteItem]? {
        let request = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        let predicate = NSPredicate(format: "link CONTAINS[C] %@", link)
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
}

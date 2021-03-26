//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI
import CoreData

struct FavoriteListView: View {
    @Binding var selection: Int
    
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel = FavoriteListViewModel()
    
    @State private var inputText = ""
    @State private var isAscending = false
    @State private var isEditing = false
    @State private var isEmpty = false
    @State private var isShowAlert = false
    @State private var isShowingKeyboard = false
    @State private var selectedItem: Item?
    @State private var sortKeyPath = \FavoriteItem.date
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if !(isShowingKeyboard) {
                    FavoriteListHeaderView(
                        isEditing: $isEditing,
                        isEmpty: $isEmpty,
                        removeItems: $viewModel.removeItems
                    )
                        .frame(height: 60)
                }
                
                FetchedItems(
                    inputText: inputText,
                    isAscending: isAscending,
                    sortKeyPath: sortKeyPath
                ) { (items: [FavoriteItem]) in
                    if (isEditing) {
                        EditButtonBarView(removeItems: $viewModel.removeItems, isShowAlert: $isShowAlert, items: items)
                            .frame(height: CGFloat(40))
                            .padding(.horizontal, CGFloat(geometry.size.height * 0.02))
                    }
                    if (items.isEmpty) {
                        VStack {
                            Spacer(minLength: 0)
                            
                            Text("お気に入りリストに登録された商品がありません")
                                .font(.system(size: CGFloat(geometry.size.height * 0.025), weight: .medium))
                            
                            Spacer(minLength: 0)
                        }
                        .onAppear {
                            isEmpty = true
                        }
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack {
                                ForEach(items) { item in
                                    CardView(
                                        isEditing: $isEditing,
                                        isShowAlert: $isShowAlert,
                                        removeItems: $viewModel.removeItems,
                                        selectedItem: $selectedItem,
                                        input: convertToItem(item: item)
                                    )
                                    .padding(CGFloat(geometry.size.height * 0.025))
                                    .frame(width: CGFloat(geometry.size.width - 30), height: CGFloat(geometry.size.height * 0.25))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke((viewModel.removeItems.firstIndex(where: {$0 == item.link}) != nil) ?  Color.blue : Color.gray, lineWidth: 1)
                                    )
                                    .padding(
                                        EdgeInsets(
                                            // ヘッダーと被らないようにするため上部に1だけpaddingを設定する
                                            // ヘッダーが隠れている時はレイアウトがつまっている印象を避けるため余白を設定する
                                            top: (isShowingKeyboard) ? CGFloat(geometry.size.height * 0.02) : 1,
                                            leading: CGFloat(geometry.size.height * 0.02),
                                            bottom: CGFloat(geometry.size.height * 0.02),
                                            trailing: CGFloat(geometry.size.height * 0.02)
                                        )
                                    )
                                } // ForEach
                            } // LazyVStack
                        } // ScrollView
                        .onAppear {
                            isEmpty = false
                        }
                    }
                }
                if !(isShowingKeyboard) {
                    SortButtonBarView(isAscending: $isAscending, sortKeyPath: $sortKeyPath)
                        .frame(height: CGFloat(30))
                        .padding(.top, CGFloat(geometry.size.height * 0.01))
                }
                
                TextFieldView(inputText: $inputText, isShowingKeyboard: $isShowingKeyboard)
                    .frame(height: CGFloat(40))
                    .padding(
                        EdgeInsets(
                            top: CGFloat(geometry.size.height * 0.01),
                            leading: CGFloat(geometry.size.height * 0.01),
                            bottom: CGFloat(geometry.size.height * 0.025),
                            trailing: CGFloat(geometry.size.height * 0.01)
                        )
                    )
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }
        } // GeometryReader
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("削除"),
                message: (isEditing) ? Text("選択した商品を削除しますか？") : Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")) {
                    viewModel.removeItems = []
                },
                secondaryButton: .destructive(Text("削除")) {
                    viewModel.removeItem()
                })
        } // .alert
        .sheet(item: $selectedItem) { item in
            ItemView(input: item, title: "詳細")
        }
        .onAppear {
            viewModel.context = context
        } // .onAppear
    } // body
    
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

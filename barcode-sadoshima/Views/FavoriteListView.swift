//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI
import CoreData

struct FavoriteListView: View {
    @Environment(\.managedObjectContext) private var context
    
    @Binding var itemDetail: Item?
    @Binding var selection: TabItem
    
    @State private var inputText = ""
    @State private var isAscending = true
    @State private var isEditing = false
    @State private var isItemsEmpty = false
    @State private var isShowingAlert = false
    @State private var isShowingKeyboard = false
    @State private var removeItems = [String]()
    @State private var sortKeyPath = \FavoriteItem.title
    
    var body: some View {
        VStack(spacing: 0) {
            if !isShowingKeyboard {
                FavoriteListViewHeader(isEditing: $isEditing, isItemsEmpty: $isItemsEmpty, removeItems: $removeItems)
                SortButtonBar(isAscending: $isAscending, sortKeyPath: $sortKeyPath)
            }
            if !isEditing {
                TextFieldView(inputText: $inputText, isShowingKeyboard: $isShowingKeyboard)
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
            }
            
            FetchedItems(
                inputText: inputText,
                isAscending: isAscending,
                sortKeyPath: sortKeyPath
            ) { (items: [FavoriteItem]) in
                if isEditing {
                    EditButtonBar(
                        isShowingAlert: $isShowingAlert,
                        removeItems: $removeItems,
                        items: items
                    )
                    .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)))
                }
                
                if (items.isEmpty) {
                    VStack {
                        Spacer(minLength: 0)
                        
                        Text("お気に入りリストに登録された商品がありません")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                    }
                    .onAppear {
                        isItemsEmpty = true
                    }
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading) {
                            ForEach(items) { item in
                                HStack {
                                    Button(action: {
                                        if isEditing {
                                            if let itemIndex = removeItems.firstIndex(where: {$0 == item.link}) {
                                                removeItems.remove(at: itemIndex)
                                            } else {
                                                removeItems.append(item.link)
                                            }
                                        } else {
                                            itemDetail = convertToItem(item: item)
                                        }
                                    }, label: {
                                        CardView(selection: $selection, input: convertToItem(item: item))
                                    })
                                    
                                    TrashButtonView(
                                        isEditing: $isEditing,
                                        isShowingAlert: $isShowingAlert,
                                        removeItems: $removeItems,
                                        removeItem: item.link)
                                }
                                .frame(height: 180)
                                .frame(minWidth: 300)
                                .background(
                                    Group {
                                        if removeItems.firstIndex(where: {$0 == item.link}) != nil {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.offWhite)
                                                .frame(height: 180)
                                                .frame(minWidth: 300)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .stroke(Color.gray, lineWidth: 4)
                                                        .blur(radius: 4)
                                                        .offset(x: 2, y: 2)
                                                        .mask(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(Color.black, Color.clear)))
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .stroke(Color.white, lineWidth: 8)
                                                        .blur(radius: 4)
                                                        .offset(x: -2, y: -2)
                                                        .mask(RoundedRectangle(cornerRadius: 25).fill(LinearGradient(Color.clear, Color.black)))
                                                )
                                        } else {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.offWhite)
                                                .frame(height: 180)
                                                .frame(minWidth: 300)
                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                        }
                                    }
                                )
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                            } // ForEach
                        } // LazyVStack
                        .padding(.top, 10)
                        .padding(.bottom, 90)
                    } // ScrollView
                    .onAppear {
                        isItemsEmpty = false
                    }
                }
            }
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("削除"),
                message: (isEditing) ? Text("選択した商品を削除しますか？") : Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")) {
                    removeItems = []
                },
                secondaryButton: .destructive(Text("削除")) {
                    removeItem()
                })
        } // .alert
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
    
    private func removeItem() {
        removeItems.forEach { link in
            guard let item = searchItem(link) else {
                return
            }
            context.delete(item[0])
        }
        
        do {
            try context.save()
            removeItems = []
        } catch {
            fatalError()
        }
    }
    
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

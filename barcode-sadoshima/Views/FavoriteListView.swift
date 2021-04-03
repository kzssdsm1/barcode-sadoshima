//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI
import CoreData

struct FavoriteListView: View {
    @Binding var isEditing: Bool
    @Binding var isShowingKeyboard: Bool
    @Binding var isShowingAlert: Bool
    @Binding var removeItems: [String]
    @Binding var selectedItem: Item?
    @Binding var selection: TabItem
    
    @State private var inputText = ""
    @State private var isAscending = true
    @State private var sortKeyPath = \FavoriteItem.title
    @State private var isEmpty = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !isShowingKeyboard {
                FavoriteListViewHeader(isEditing: $isEditing, removeItems: $removeItems, isEmpty: $isEmpty)
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
                        removeItems: $removeItems,
                        showAlert: $isShowingAlert,
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
                        isEmpty = true
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
                                            selectedItem = convertToItem(item: item)
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
                        isEmpty = false
                    }
                }
            }
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
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

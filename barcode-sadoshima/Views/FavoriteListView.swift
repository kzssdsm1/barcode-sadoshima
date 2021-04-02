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
    @Binding var showAlert: Bool
    @Binding var removeItems: [String]
    @Binding var selectedItem: Item?
    @Binding var selection: TabItem
    @Binding var isShowingFavoriteItems: Bool
    
    @State private var inputText = ""
    @State private var isAscending = true
    @State private var sortKeyPath = \FavoriteItem.title
    @State private var isEmpty = false
    @State private var isAnimating = false
    
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
                        showAlert: $showAlert,
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
                    if isShowingFavoriteItems {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(alignment: .leading) {
                                ForEach(items) { item in
                                    CardView(
                                        isEditing: $isEditing,
                                        showAlert: $showAlert,
                                        removeItems: $removeItems,
                                        selectedItem: $selectedItem,
                                        selection: $selection,
                                        input: convertToItem(item: item))
                                        .frame(height: 180)
                                        .frame(minWidth: 300)
                                        .background(
                                            Group {
                                                if removeItems.firstIndex(where: {$0 == item.link}) == nil {
                                                    RoundedRectangle(cornerRadius: 25)
                                                        .fill(Color.offWhite)
                                                        .frame(height: 180)
                                                        .frame(minWidth: 300)
                                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                                    
                                                } else {
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
                    } else if !isShowingFavoriteItems {
                        if selection == .favorite {
                            Spacer()
                            
                            ZStack {
                                Color(.black)
                                    .opacity(0.6)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(12)
                                    .disabled(isShowingFavoriteItems)
                                
                                Circle()
                                    .trim(from: 0, to: 0.6)
                                    .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                                            style: StrokeStyle(
                                                lineWidth: 8,
                                                lineCap: .round,
                                                dash: [0.1, 16],
                                                dashPhase: 8))
                                    .frame(width: 60, height: 60)
                                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                                    .onAppear() {
                                        withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                            self.isAnimating = true
                                        }
                                    }
                                    .onDisappear() {
                                        self.isAnimating = false
                                    }
                            } // ZStack
                            .drawingGroup()
                            
                            Spacer(minLength: 300)
                        } else {
                            Spacer()
                        }
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

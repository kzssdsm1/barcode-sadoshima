//
//  SearchView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/31.
//

import SwiftUI
import Combine

struct SearchView: View {
    @Binding var isLoading: Bool
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    @Binding var showItems: [Item]
    @Binding var selectedItem: Item?
    @Binding var selection: TabItem
    
    @State private var inputText = ""
    @Binding var isShowingKeyboard: Bool
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var removeItems = [String]()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("タイトルで検索")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                Spacer(minLength: 0)
            } // HStack
            .frame(height: 60)
            
            SearchTextFieldView(
                inputText: $inputText,
                isShowingKeyboard: $isShowingKeyboard,
                onCommitSubject: $onCommitSubject,
                isLoading: $isLoading
            )
            
            if (showItems.isEmpty) {
                VStack {
                    Spacer(minLength: 0)
                    
                    Text("一致する書籍が見つかりませんでした")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                    
                    Spacer(minLength: 0)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        ForEach(showItems) { item in
                            CardView(
                                isEditing: $isEditing,
                                showAlert: $showAlert,
                                removeItems: $removeItems,
                                selectedItem: $selectedItem,
                                selection: $selection,
                                input: item)
                                .frame(width: screenWidth - 20, height: 180)
                                .background(
                                    Group {
                                        if removeItems.firstIndex(where: {$0 == item.link}) == nil {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.offWhite)
                                                .frame(width: screenWidth - 20, height: 180)
                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                            
                                        } else {
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.offWhite)
                                                .frame(width: screenWidth - 20, height: 180)
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
                                .padding(.horizontal, 10)
                                .padding(.vertical, 10)
                        }
                    }
                } // ScrollView
                .padding(.top, 10)
            }
        } //VStack
        .disabled(isLoading)
    } // body
}

//
//  SearchView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/31.
//

import SwiftUI
import Combine

struct SearchView: View {
    @Binding var alertItem: AlertItem?
    @Binding var isLoading: Bool
    @Binding var itemDetail: Item?
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    @Binding var searchResults: [Item]
    @Binding var selection: TabItem
    
    @State private var inputText = ""
    @State private var isShowingKeyboard = false
    
    var body: some View {
        VStack(spacing: 0) {
            if !isShowingKeyboard {
                HStack {
                    Text("タイトルで検索")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.gray)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        withAnimation {
                            searchResults = []
                            inputText = ""
                        }
                    }) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(searchResults.isEmpty ? .gray : .accentColor)
                                    .offset(y: -5)
                            )
                            .background(
                                Text("クリア")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(searchResults.isEmpty ? .gray : .accentColor)
                                    .offset(y: 12)
                            )
                    }
                    .buttonStyle(CustomButtonStyle())
                    .frame(width: 50, height: 50)
                    .disabled(searchResults.isEmpty)
                    .padding(.trailing, 10)
                } // HStack
                .padding(10)
                .frame(height: 60)
            }
            
            SearchTextFieldView(
                alertItem: $alertItem, 
                inputText: $inputText,
                isShowingKeyboard: $isShowingKeyboard,
                isLoading: $isLoading,
                onCommitSubject: $onCommitSubject
            )
            
            if (searchResults.isEmpty) {
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
                        ForEach(searchResults) { item in
                            Button(action: {
                                itemDetail = item
                            }, label: {
                                CardView(selection: $selection, input: item)
                            })
                            .frame(height: 180)
                            .frame(minWidth: 300)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.offWhite)
                                    .frame(height: 180)
                                    .frame(minWidth: 300)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            )
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                        } // ForEach
                    } // LazyVStack
                    .padding(.top, 10)
                    .padding(.bottom, 90)
                } // ScrollView
            }
        } //VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
        .disabled(isLoading)
    } // body
}

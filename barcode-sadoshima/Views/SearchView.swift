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
    @Binding var isShowingKeyboard: Bool
    @Binding var isShowingItems: Bool
    
    @State private var inputText = ""
    @State private var isEditing = false
    @State private var showAlert = false
    @State private var removeItems = [String]()
    @State private var isAnimating = false
    
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
                            showItems = []
                            inputText = ""
                        }
                    }) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(showItems.isEmpty ? .gray : .accentColor)
                                    .offset(y: -5)
                            )
                            .background(
                                Text("クリア")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(showItems.isEmpty ? .gray : .accentColor)
                                    .offset(y: 12)
                            )
                    }
                    .buttonStyle(CustomButtonStyle())
                    .frame(width: 50, height: 50)
                    .disabled(showItems.isEmpty)
                    .padding(.trailing, 10)
                } // HStack
                .padding(10)
                .frame(height: 60)
            }
            
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
                if isShowingItems {
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
                } else if !isShowingItems {
                    if selection == .検索 {
                        Spacer()
                        
                        ZStack {
                            Color(.black)
                                .opacity(0.6)
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                                .disabled(isShowingItems)
                            
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
        } //VStack
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .disabled(isLoading)
    } // body
}

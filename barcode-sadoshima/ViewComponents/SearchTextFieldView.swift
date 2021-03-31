//
//  SearchTextFieldView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/31.
//

import SwiftUI
import Combine

struct SearchTextFieldView: View {
    @Binding var inputText: String
    @Binding var isShowingKeyboard: Bool
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    @Binding var isLoading: Bool
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                
                TextField("タイトルで検索", text: $inputText, onCommit: {
                    isLoading = true
                    onCommitSubject.send(inputText)
                })
                    .textFieldStyle(CustomTextFieldStyle())
            } // HStack
            .padding(3)
            .frame(maxWidth: screenWidth - 50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            
            if (isShowingKeyboard) {
                Button(action: {
                    UIApplication.shared.closeKeyboard()
                }) {
                    Text("キャンセル")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 14, weight: .medium))
                        .padding(.leading, 10)
                }
                .transition(AnyTransition.opacity.combined(with: .scale))
            }
        } // HStack
        .padding(10)
        .frame(maxWidth: screenWidth - 30)
        .frame(height: 45)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.offWhite)
                .frame(width: screenWidth - 20, height: 45)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
        )
        .padding(.vertical, 15)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            withAnimation {
                isShowingKeyboard = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            withAnimation {
                isShowingKeyboard = false
            }
        }
    } // body
}

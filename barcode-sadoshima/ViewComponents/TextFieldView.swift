//
//  TextFieldView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/11.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var inputText: String
    @Binding var isShowingKeyboard: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                    
                    TextField("タイトルで検索", text: $inputText)
                        .textFieldStyle(CustomTextFieldStyle())
                } // HStack
                .padding(CGFloat(geometry.size.height * 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                
                if (isShowingKeyboard) {
                    Button(action: {
                        UIApplication.shared.closeKeyboard()
                    }) {
                        Text("キャンセル")
                            .foregroundColor(.blue)
                            .font(.system(size: CGFloat(geometry.size.height * 0.4), weight: .medium))
                            .padding(.leading, CGFloat(geometry.size.height * 0.15))
                    }
                    .transition(AnyTransition.opacity.combined(with: .scale))
                }
            } // HStack
            .padding(
                EdgeInsets(
                    top: CGFloat(geometry.size.height * 0.1),
                    leading: CGFloat(geometry.size.height * 0.15),
                    bottom: CGFloat(geometry.size.height * 0.1),
                    trailing: CGFloat(geometry.size.height * 0.15)
                )
            )
        } // GeometryReader
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

struct CustomTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: CGFloat(20)))
            .background(colorScheme == .dark ? Color.black : Color.white)
            .foregroundColor(.gray)
    }
}

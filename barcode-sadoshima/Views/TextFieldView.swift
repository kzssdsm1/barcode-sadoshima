//
//  TextFieldView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI

struct TextFieldView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var inputText: String = ""
    @State private var isAscending = false
    @State private var isShowingKeyboard = false
    @State private var sortPath = \FavoriteItem.date
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                FavoriteListView(inputText: inputText, isAscending: isAscending, sortPath: sortPath)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if !(isShowingKeyboard) {
                    SortButtonBarView(isAscending: $isAscending, sortPath: $sortPath)
                        .frame(height: (geometry.size.height * 0.035))
                        .padding(CGFloat(geometry.size.height * 0.01))
                }
                
                HStack {
                    TextField("タイトルを入力(かな・漢字完全一致)", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .cornerRadius(12)
                        .padding(.trailing, CGFloat(geometry.size.height * 0.01))
                    
                    if (isShowingKeyboard) {
                        Button(action: {
                            UIApplication.shared.closeKeyboard()
                        }) {
                            Text("キャンセル")
                                .foregroundColor(.blue)
                                .font(.system(size: (geometry.size.height * 0.034), weight: .medium))
                        }
                    }
                }
                .frame(height: 40)
                .padding(.horizontal, CGFloat(geometry.size.height * 0.02))
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            isShowingKeyboard = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            isShowingKeyboard = false
        }
    }
}

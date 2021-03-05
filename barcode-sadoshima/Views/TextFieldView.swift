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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                FavoriteListView(inputText: inputText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                TextField("タイトルを入力(かな・漢字完全一致)", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .cornerRadius(12)
                    .padding(.horizontal, CGFloat(geometry.size.height * 0.02))
            }
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        }
    }
}

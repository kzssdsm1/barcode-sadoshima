//
//  CustomTextFieldStyle.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/05.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    @Binding var isEditing: Bool
    @Binding var inputText: String
    
    let isSearchView: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.black)
            .background(
                ZStack(alignment: .leading) {
                    Color.offWhite
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Text(isSearchView ? "キーワードを入力(タイトル、著者名等)" : "タイトルか著者名で絞り込み")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .opacity(!isEditing && inputText == "" ? 0.3 : 0)
                }
            )
    }
}

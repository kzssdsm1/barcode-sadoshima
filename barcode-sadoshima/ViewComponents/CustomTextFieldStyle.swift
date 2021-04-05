//
//  CustomTextFieldStyle.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/05.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle { 
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 18))
            .foregroundColor(.black)
            .background(Color.offWhite)
    }
}

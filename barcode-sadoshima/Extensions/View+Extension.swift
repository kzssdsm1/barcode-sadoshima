//
//  View+Extension.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/05.
//

import SwiftUI

extension View {
    func hide(_ hide: Bool) -> some View {
        HideableView(isHidden: .constant(hide), view: self)
    }
    
    func hide(_ isHidden: Binding<Bool>) -> some View {
        HideableView(isHidden: isHidden, view: self)
    }
}

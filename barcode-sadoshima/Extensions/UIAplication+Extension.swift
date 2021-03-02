//
//  UIAplication+Extension.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/03.
//

import UIKit

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

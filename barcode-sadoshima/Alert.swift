//
//  Alert.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let dismissButton: Alert.Button
}

struct AlertContext {
    static let invalidDeviceInput = AlertItem(
        title: "無効なデバイス入力",
        message: "不明なエラーによりバーコードが読み取れませんでした",
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidScannedType = AlertItem(
        title: "無効なバーコード形式",
        message: "このアプリはEAN-8、EAN-13以外のバーコード形式には対応しておりません",
        dismissButton: .default(Text("OK"))
    )
}

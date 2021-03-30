//
//  Alert.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct AlertContext {
    static let invalidDeviceAction = AlertItem(
        title: "無効なデバイス入力",
        message: "不明なエラーによりバーコードが読み取れませんでした"
    )
    
    static let invalidScannedValue = AlertItem(
        title: "無効なバーコード形式",
        message: "このアプリはEAN-8、EAN-13以外のバーコード形式には対応しておりません"
    )
    
    static let invalidURLSession = AlertItem(
        title: "問題が発生しました",
        message: "通信状況に問題があるか、楽天ブックスでは現在取り扱っていない商品の可能性があります"
    )
}

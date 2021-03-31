//
//  TabItem.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case スキャナー
    case 検索
    case お気に入り
    case 使い方
    
    var imageName: String {
        switch self {
        case .スキャナー: return "camera.fill"
        case .検索: return "magnifyingglass"
        case .お気に入り: return "star.fill"
        case .使い方: return "questionmark.circle.fill"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .スキャナー: return .blue
        case .検索: return .purple
        case .お気に入り: return .yellow
        case .使い方: return .green
        }
    }
}

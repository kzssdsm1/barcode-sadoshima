//
//  TabItem.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case scanner
    case search
    case favorite
    case usage
    
    var imageName: String {
        switch self {
        case .scanner: return "camera.fill"
        case .search: return "magnifyingglass"
        case .favorite: return "star.fill"
        case .usage: return "questionmark.circle.fill"
        }
    }
    
    var buttonColor: Color {
        switch self {
        case .scanner: return .calmBlue
        case .search: return .deepPurple
        case .favorite: return .yellow
        case .usage: return .vividGreen
        }
    }
    
    var buttonText: String {
        switch self {
        case .scanner: return "スキャナー"
        case .search: return "検索"
        case .favorite: return "お気に入り"
        case .usage: return "使い方"
        }
    }
}

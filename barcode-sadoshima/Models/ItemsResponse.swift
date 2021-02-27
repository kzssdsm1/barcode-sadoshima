//
//  ItemsResponse.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation

struct ItemsResponse: Codable {
    let items: [Items]
    
    private enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

struct Items: Codable {
    let author: String
    let title: String
    let largeImageUrl: String
    let itemPrice: Int
    let itemUrl: String
}

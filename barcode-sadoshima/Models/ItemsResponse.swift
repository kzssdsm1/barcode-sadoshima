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
    let itemCaption: String
    let publisherName: String
    let isbn: String
    let itemUrl: String
    let largeImageUrl: String
    let salesDate: String
    let itemPrice: Int
}

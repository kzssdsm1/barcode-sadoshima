//
//  Item.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import Foundation

struct Item: Identifiable {
    let id = UUID()
    let author: String
    let date: String
    let image: String
    let link: String
    let price: String
    let title: String
}

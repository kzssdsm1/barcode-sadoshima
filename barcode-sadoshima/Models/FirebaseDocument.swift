//
//  FirebaseDocument.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation

struct FirebaseDocument: Codable {
    let author: String
    let title: String
    let image: String
    let price: String
    let link: String
    let createdAt: Date
}

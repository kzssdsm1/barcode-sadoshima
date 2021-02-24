//
//  DocumentModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/24.
//

import Foundation

struct DocumentModel: Identifiable {
    let id: String
    let author: String
    let title: String
    let image: String
    let price: String
    let link: String
    let createdAt: Date
}

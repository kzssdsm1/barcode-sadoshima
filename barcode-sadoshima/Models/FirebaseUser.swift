//
//  FirebaseUser.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation

struct FirebaseUser: Equatable {
    let uid: String
    let name: String
    let pohoto: Data?
}

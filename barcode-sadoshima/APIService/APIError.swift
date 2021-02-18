//
//  APIError.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation

enum APIError: Error {
    case parseError
    case responseError
    case unknownError(String)
}

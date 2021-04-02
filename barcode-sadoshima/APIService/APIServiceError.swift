//
//  APIServiceError.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case invalidResponse
    case requestError(_ statusCode: Int)
    case serverError(_ statusCode: Int)
    case parseError(Error)
    case unknownError(reason: String)
}

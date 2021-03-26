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
    case unknownError
}

extension APIServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "通信の際に問題が発生しました"
        case .invalidResponse:
            return "通信の際に問題が発生しました"
        case .requestError(_):
            return "通信の際に問題が発生しました"
        case .serverError(_):
            return "通信の際に問題が発生しました"
        case .parseError(_):
            return "楽天ブックスでは現在取り扱っていないようです"
        case .unknownError:
            return "通信の際に問題が発生しました"
        }
    }
}

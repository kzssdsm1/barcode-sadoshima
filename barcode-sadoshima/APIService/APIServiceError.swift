//
//  APIServiceError.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation

enum APIServiceError: Error {
    case invalidURL
    case requestError(statusCode: Int)
    case serverError(statusCode: Int)
    case parseError
    case unknownError(reason: Error)
    case invalidNetwork
    case timedOut
    case reachTheRequestLimit
    case reachTheServerLimit
    case apiServiceError
}

extension APIServiceError {
    var errorTitle: String {
        switch self {
        case .invalidURL: return "URLエラー"
        case .timedOut: return "タイムアウト"
        case .requestError, .reachTheRequestLimit: return "リクエストエラー"
        case .serverError, .reachTheServerLimit, .apiServiceError: return "サーバーエラー"
        case .parseError: return "データが見つかりませんでした"
        case .invalidNetwork: return "ネットワークが見つかりませんでした"
        default: return "不明なエラー"
        }
    }
    
    var errorDesc: String {
        switch self {
        case .invalidURL: return "不正なURLです、再度お試しください"
        case .timedOut: return "通信がタイムアウトしました、通信環境をご確認ください"
        case .requestError: return "リクエストに問題が発生しているようです(エラーコード \(getStatusCode(error: self)!))"
        case .serverError: return "サーバーに問題が発生しているようです(エラーコード \(getStatusCode(error: self)!))"
        case .parseError: return "楽天ブックス書籍検索APIにデータが存在しません"
        case .invalidNetwork: return "インターネットに接続されていないようです"
        case .reachTheRequestLimit: return "一定時間内に送れるリクエストの上限に達したようです、時間を置いた後に再度お試しください(エラーコード: 429)"
        case .reachTheServerLimit: return "サーバー全体のリクエスト上限に達したか、現在メンテナンス中です(エラーコード: 503)"
        case .apiServiceError: return "楽天ウェブサービスに何らかの障害が発生しているようです(エラーコード: 500)"
        default: return "不明なエラーが発生しました"
        }
    }
    
    private func getStatusCode(error: APIServiceError) -> Int? {
        switch error {
        case let APIServiceError.serverError(statusCode):
            return statusCode
        case let APIServiceError.requestError(statusCode):
            return statusCode
        default:
            return nil
        }
    }
}

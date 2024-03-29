//
//  APIService.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype ResponseType
    
    var baseURLString: String { get }
    var pathString: String { get }
    var queryItems: [URLQueryItem] { get }
}

protocol APIServiceType {
    func request<T, V>(_ request: T) -> AnyPublisher<V, APIServiceError> where T: APIRequestType, V: Codable, T.ResponseType == V
}

final class APIService: APIServiceType {
    /// キャッシュが残っていても常にサーバーにリクエストを送るための設定
    private let cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    /// 応答待機時間
    private let timeInterval: TimeInterval = 8
    
    /// APIリクエストを行う関数
    /// - Parameter request: 別途定義したRequestパラメーターを取りまとめた構造体
    /// - Returns: APIリクエスト、成功した場合sinkでレスポンスを受け取れる
    func request<T, V>(_ request: T) -> AnyPublisher<V, APIServiceError> where T: APIRequestType, V: Codable, V == T.ResponseType {
        guard let pathURL = URL(string: request.pathString, relativeTo: URL(string: request.baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let request = buildURLRequest(url: pathURL, queryItems: request.queryItems)
        let decoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    switch (response as! HTTPURLResponse).statusCode {
                    case (400..<500):
                        switch (response as! HTTPURLResponse).statusCode {
                        case 429: throw APIServiceError.reachTheRequestLimit
                        default: throw APIServiceError.requestError(statusCode: (response as! HTTPURLResponse).statusCode)
                        }
                    default:
                        switch (response as! HTTPURLResponse).statusCode {
                        case 500: throw APIServiceError.apiServiceError
                        case 503: throw APIServiceError.reachTheServerLimit
                        default: throw APIServiceError.serverError(statusCode: (response as! HTTPURLResponse).statusCode)
                        }
                    }
                }
                return data
            }
            .decode(type: V.self, decoder: decoder)
            .mapError({ (error) -> APIServiceError in
                if let error = error as? APIServiceError {
                    return error
                }
                
                if let error = error as? URLError {
                    if error.code == URLError.timedOut {
                        return APIServiceError.timedOut
                    } else if error.code == URLError.dataNotAllowed {
                        return APIServiceError.invalidNetwork
                    }
                }
                
                if error is DecodingError {
                    return APIServiceError.parseError
                }
                
                return APIServiceError.unknownError(reason: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// URLRequestを組み立てる関数
    /// - Parameters:
    ///   - url: スキーマとドメインとパスからなるベースURL
    ///   - queryItems: APIリクエストパラメーター
    /// - Returns: dataTuskPublisherで使用するURLRequest
    private func buildURLRequest(url: URL, queryItems: [URLQueryItem]) -> URLRequest {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = queryItems
        
        var request = URLRequest(
            url: urlComponents.url!,
            cachePolicy: cachePolicy,
            timeoutInterval: timeInterval)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}

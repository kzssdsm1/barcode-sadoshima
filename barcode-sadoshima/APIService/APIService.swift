//
//  APIService.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
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
    private let cachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeInterval: TimeInterval = 30
    
    func request<T, V>(_ request: T) -> AnyPublisher<V, APIServiceError> where T: APIRequestType, V: Codable, V == T.ResponseType {
        guard let pathURL = URL(string: request.pathString, relativeTo: URL(string: request.baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let request = buildURLRequest(url: pathURL, queryItems: request.queryItems)
        let decoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIServiceError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    switch httpResponse.statusCode {
                    case (400..<500):
                        throw APIServiceError.requestError(httpResponse.statusCode)
                    default:
                        throw APIServiceError.serverError(httpResponse.statusCode)
                    }
                }
                return data
            }
            .mapError { $0 as! APIServiceError }
            .decode(type: V.self, decoder: decoder)
            .mapError { error in
                if let err = error as? DecodingError {
                    var errorToReport = error.localizedDescription
                    switch err {
                    case .dataCorrupted(let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) - (\(details))"
                    case .keyNotFound(let key, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (key: \(key), \(details))"
                    case .typeMismatch(let type, let context), .valueNotFound(let type, let context):
                        let details = context.underlyingError?.localizedDescription ?? context.codingPath.map { $0.stringValue }.joined(separator: ".")
                        errorToReport = "\(context.debugDescription) (type: \(type), \(details))"
                    @unknown default:
                        break
                    }
                    return APIServiceError.parseError(errorToReport)
                } else {
                    return APIServiceError.unknownError(error.localizedDescription)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
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

//
//  NetworkPublisher.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation
import Combine
import Alamofire

struct NetworkPublisher {

  private static let successRange = 200 ..< 300
  private static let contentType = "application/json"
  private static let retryCount: Int = 1
  static let decorder: JSONDecoder = {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    return jsonDecoder
  }()

  static func publish<T, V>(_ request: T) -> Future<V, APIError>
    where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
      return Future { promise in
        let api = AF.request(request)
          .validate(statusCode: self.successRange)
          .validate(contentType: [self.contentType])
          .cURLDescription { text in
            print(text)
        }
        .responseJSON { response in
          switch response.result {
          case .success:
            do {
              if let data = response.data {
                let json = try self.decorder.decode(V.self, from: data)
                promise(.success(json))
              } else {
                promise(.failure(APIError.responseError))
              }
            } catch {
              promise(.failure(APIError.parseError))
            }
          case let .failure(error):
            promise(.failure(APIError.unknownError(error.errorDescription ?? "")))
          }
        }
        api.resume()
      }
  }
}

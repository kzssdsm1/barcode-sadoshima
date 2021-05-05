//
//  ItemsRequest.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation

// MARK: - APIリクエストの構造体
struct ItemsRequest: APIRequestType {
    typealias ResponseType = ItemsResponse
    
    // 末尾はcomやjpなどのトップレベルドメインじゃないとリクエストに利用できない
    var baseURLString: String {
        return "https://app.rakuten.co.jp/"
    }
    
    var pathString: String {
        return "services/api/BooksTotal/Search/20170404"
    }
    
    var queryItems: [URLQueryItem] {
        if useISBN {
            return [
                .init(name: "isbnjan", value: query),
                .init(name: "elements", value: "title,author,publisherName,isbn,itemCaption,salesDate,itemPrice,itemUrl,largeImageUrl,artistName,label"),
                .init(name: "formatVersion", value: "2"),
                .init(name: "hits", value: "1"),
                .init(name: "outOfStockFlag", value: "1"),
                .init(name: "applicationId", value: getAppID())
            ]
        } else {
            return [
                .init(name: "keyword", value: query),
                .init(name: "elements", value: "title,author,publisherName,isbn,itemCaption,salesDate,itemPrice,itemUrl,largeImageUrl,artistName,label"),
                .init(name: "formatVersion", value: "2"),
                .init(name: "hits", value: "30"),
                .init(name: "outOfStockFlag", value: "1"),
                .init(name: "applicationId", value: getAppID())
            ]
        }
    }
    
    private let query: String
    private let useISBN: Bool
    
    init(query: String, useISBN: Bool) {
        self.query = query
        self.useISBN = useISBN
    }
    
    /// Property ListからapplicationIDを読み取る関数
    /// - Returns: applicationID
    private func getAppID() -> String {
            let filePath = Bundle.main.path(forResource: "AppID", ofType: "plist")!
            let plist = NSDictionary(contentsOfFile: filePath)!
            let appID = String(describing:plist["appID"]!)
            
            return appID
        }
}

//
//  ItemsRequest.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import Foundation

struct ItemsRequest: APIRequestType {
    typealias ResponseType = ItemsResponse
    
    var baseURLString: String {
        return "https://app.rakuten.co.jp/"
    }
    
    var pathString: String {
        return "/services/api/BooksBook/Search/20170404"
    }
    
    var queryItems: [URLQueryItem] {
        return [
            //.init(name: "format", value: "json"),
            .init(name: "isbn", value: query),
            .init(name: "elements", value: "author,title,largeImageUrl,itemPrice,itemUrl"),
            .init(name: "formatVersion", value: "2"),
            .init(name: "hits", value: "1"),
            .init(name: "applicationId", value: getAppID())
        ]
    }
    
    private let query: String
    
    init(query: String) {
        self.query = query
    }
    
    private func getAppID() -> String {
            let filePath = Bundle.main.path(forResource: "AppID", ofType: "plist")!
            let plist = NSDictionary(contentsOfFile: filePath)!
            let appID = String(describing:plist["appID"]!)
            
            return appID
        }
}

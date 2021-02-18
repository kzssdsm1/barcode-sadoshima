//
//  ItemsRequest.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation
import Alamofire

class ItemsRequest: BaseRequestProtocol {
    typealias ResponseType = [ItemsResponse]
    
    var parameters: Parameters? {
        return [
            "isbn": query,
            "formatVersion": "2",
            "hits": "1",
            "elements": "author,title,largeImageUrl,itemPrice,itemUrl",
            "applicationId": getAppID()
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/BooksBook/Search/20170404"
    }
    
    var allowsConstrainedNetworkAccess: Bool {
        return false
    }
    
    private let query: String
    
    init(query: String) {
        self.query = query
    }
    
    private func getAppID() -> String{
        let filePath = Bundle.main.path(forResource: "AppID", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: filePath)!
        let appID = String(describing:plist["appID"]!)
        
        return appID
    }
}

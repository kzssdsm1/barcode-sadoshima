//
//  RakutenAPIDataModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/21.
//

import Foundation
import Alamofire

final class RakutenAPIDataModel {
    
    private struct ItemsJSON: Codable {
        struct Item: Codable {
            let title: String
            let mediumImageUrl: String
            let itemPrice: String
            let itemUrl: String
        }
        let items: [Item]
    }
    
    private let baseURL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?"
    
    func searchItem(isbn: String) {
        let filePath = Bundle.main.path(forResource: "AppID", ofType:"plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)!
        let appID = String(describing:plist["appID"]!)
        
        let params = ["applicationId": appID, "format": "json", "isbn": isbn]
        
        AF.request(baseURL,parameters: params).responseJSON { response in
            guard let data = response.data else { return }
            
            let itemsData = try! JSONDecoder().decode(ItemsJSON.self, from: data)
        }
    }
}

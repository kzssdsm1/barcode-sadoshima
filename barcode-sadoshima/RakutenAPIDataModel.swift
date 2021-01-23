//
//  RakutenAPIDataModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/23.
//

import Foundation
import Alamofire

final class RakutenAPIDataModel: ObservableObject {
    @Published var scannedCode = ""
    
    private struct ItemsJSON: Codable {
        let Items: [Items]
    }
    
    private struct Items: Codable {
        let title: String
        let mediumImageUrl: String
        let itemUrl: String
        private enum CodingKeys: String, CodingKey {
            case title
            case mediumImageUrl
            case itemUrl
        }
    }
    
    func fetchItem() {
        let baseURL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?"
        
        let filePath = Bundle.main.path(forResource: "AppID", ofType:"plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)!
        let appID = String(describing:plist["appID"]!)
        
        let params = [
            "applicationId": appID,
            "elements": "title,mediumImageUrl,itemUrl",
            "formatVersion": "2",
            "isbn": scannedCode,
            "hits": "1"
        ]
        
        AF.request(baseURL, method: .get, parameters: params, encoding: URLEncoding.default).response {
            response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                
                let decoder = JSONDecoder()
                let itemsData = try! decoder.decode(ItemsJSON.self, from: data)
                
                let url = URL(string: itemsData.Items[0].itemUrl)
                UIApplication.shared.open(url!)
            
            case .failure(let error):
                print(error)
            }
        }
    }
}

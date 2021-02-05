//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/05.
//

import SwiftUI
import Alamofire

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @State var isShowSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                BarcodeScannerView(scannedCode: $viewModel.scannedCode, alertItem: $viewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer().frame(height: 60)
                
                Label("バーコード", systemImage: "barcode.viewfinder")
                
                Button(action: {
                    fetchItem()
                }) {
                    Text(viewModel.statusText)
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(viewModel.statusTextColor)
                        .padding()
                }.disabled(viewModel.scannedCodeIsValid)
                
            }
            .navigationTitle("バーコードスキャナー")
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert.init(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
            }
        }
    }
    
    private func fetchItem() {
        
        struct ItemsJSON: Codable {
            let items: [Items]
            struct Items: Codable {
                let title: String
                let mediumImageUrl: String
                let itemPrice: Int
                let itemUrl: String
            }
        }
        
        let baseURL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?"
        
        let filePath = Bundle.main.path(forResource: "AppID", ofType:"plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)!
        let appID = String(describing:plist["appID"]!)
        
        let params = [
            "applicationId": appID,
            "elements": "title,mediumImageUrl,itemPrice,itemUrl",
            "formatVersion": "2",
            "isbn": viewModel.scannedCode,
            "hits": "1"
        ]
        
        AF.request(baseURL, method: .get, parameters: params, encoding: URLEncoding.default).response {
            response in
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                
                let decoder = JSONDecoder()
                let itemsData = try! decoder.decode(ItemsJSON.self, from: data)
                
                let url = URL(string: itemsData.items[0].itemUrl)
                UIApplication.shared.open(url!)
                
            case .failure(let error):
                print(error)
            }
        }
        
        isShowSheet = true
    }
}


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
    
    @State var productData = (title: "", author: "", price: "", link: "")
    @State var imageData: Data? = nil
    @State var isShowSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                BarcodeScannerView(scannedCode: $viewModel.scannedCode, alertItem: $viewModel.alertItem)
                    .frame(maxWidth: .infinity, maxHeight: 300)
                
                Spacer()
                    .frame(height: 60)
                
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
            .sheet(isPresented: $isShowSheet, content: {
                ProductView(imageData: $imageData, productData: $productData)
            })
        }
    }
    private func fetchItem() {
        
        struct ItemsJSON: Codable {
            let Items: [Items]
        }
        
        struct Items: Codable {
            let title: String
            let author: String
            let itemPrice: Int
            let itemUrl: String
            let largeImageUrl: String
            enum CodingKeys: String, CodingKey {
                case title
                case author
                case itemPrice
                case itemUrl
                case largeImageUrl
            }
        }
        
        let baseURL = "https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404?"
        
        let filePath = Bundle.main.path(forResource: "AppID", ofType:"plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)!
        let appID = String(describing:plist["appID"]!)
        
        let params = [
            "applicationId": appID,
            "elements": "title,author,itemPrice,itemUrl,largeImageUrl",
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
                let price = itemsData.Items[0].itemPrice
                
                productData.title = itemsData.Items[0].title
                productData.author = itemsData.Items[0].author
                productData.price = String(price)
                productData.link = itemsData.Items[0].itemUrl
                
                downloadImage(url: itemsData.Items[0].largeImageUrl)
                
            case .failure(let error):
                print(error)
            }
        }
        
        isShowSheet = true
    }
    
    private func downloadImage(url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL)
            imageData = data
        }
    }
}


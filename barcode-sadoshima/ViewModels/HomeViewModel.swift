//
//  HomeViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var isShowSheet = false
    // BarcodeScannerViewを表示するかを管理する変数
    @Published var isSessionStart = true
    // 読み取られたISBNコードをキャッチしてストリームを流す変数
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    @Published var productData = (author: "", title: "", image: "", price: "", link: "")
    @Published var selection = 1
    
    private let apiService: APIServiceType
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    var titleString: String {
        if self.selection == 1 {
            return "バーコードスキャナー"
        } else if self.selection == 2 {
            return "お気に入りリスト"
        } else if self.selection == 3 {
            return "アカウント"
        } else {
            return "バーコードスキャナー"
        }
    }
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        
        bind()
    }
    
    private func bind() {
        // ストリームが流れるとAPIリクエストを行う
        let responseSubscriber = onCommitSubject
            .flatMap { [apiService] (query) in
                apiService.request(ItemsRequest(query: query))
                    // 戻り値がEmpty Publisherなので実際にはストリームは流れない
                    .catch { [weak self] error -> Empty<ItemsResponse, Never> in
                        // errorSubjectにストリームを流す
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            // 流れる値をproductDataに格納してsheetを開く
            .map { $0.items }
            .sink { [weak self] (item) in
                guard let self = self else { return }
                let price = String(item[0].itemPrice)
                self.productData = (
                    author: item[0].author,
                    title: item[0].title,
                    image: item[0].largeImageUrl,
                    price: price,
                    link: item[0].itemUrl
                )
                self.isSessionStart = false
                self.isShowSheet = true
            }
        
        // エラーが返された場合errorSubjectにストリームが流れる
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                print(error)
                guard let self = self else { return }
                self.alertItem = AlertContext.invalidURLSession
            })
        
        // ストリームを流し続けるとメモリリークを起こすため購読を中止する
        cancellables += [
            responseSubscriber,
            errorSubscriber
        ]
    }
}

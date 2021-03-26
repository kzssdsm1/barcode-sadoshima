//
//  HomeViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var item: Item?
    @Published var isLoading = false
    @Published var isShowSheet = false
    /// BarcodeScannerViewでISBNコードを読み取るとストリームを流すPublisher（値そのものを保持しない）
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    
    private let apiService: APIServiceType
    /// エラーが返されるとストリームを流すPublisher
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        
        bind()
    }
    
    /// ストリームが流れるとAPIリクエストを行うメソッド
    private func bind() {
        // ストリームが流れるとAPIリクエストを行う
        let responseSubscriber = onCommitSubject
            .flatMap { [apiService] (query) in
                apiService.request(ItemsRequest(query: query))
                    // 戻り値がEmptyになっているためこの節では実際にはストリームが流れない
                    .catch { [weak self] error -> Empty<ItemsResponse, Never> in
                        // エラーを検知するとストリームを流す
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .map { $0.items }
            .sink { [weak self] (item) in
                guard let self = self else {
                    return
                }
                self.isLoading = false
                self.item = self.convertToItem(item: item)
                self.isShowSheet = true
            }
        
        // ストリームが流れるとエラーアラートを出す
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                guard let self = self else {
                    return
                }
                self.isLoading = false
                if error.errorDescription == "楽天ブックスでは現在取り扱っていないようです" {
                    self.alertItem = AlertContext.dontExistsData
                } else {
                    self.alertItem = AlertContext.invalidURLSession
                }
            })
        
        // ストリームを流し続けるとメモリリークを起こすためSubscribeを中止する
        cancellables += [
            responseSubscriber,
            errorSubscriber
        ]
    }
    
    /// APIサーバーから返ってきたJSON構造体をItem型の構造体に変換する関数
    /// - Parameter item: JSONのResponseModel
    /// - Returns:
    private func convertToItem(item: [Items]) -> Item {
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let date = formatter.string(from: Date())
        let price = String(item[0].itemPrice)
        
        return Item(
            author: item[0].author,
            date: date,
            image: item[0].largeImageUrl,
            link: item[0].itemUrl,
            price: price,
            title: item[0].title
        )
    }
}

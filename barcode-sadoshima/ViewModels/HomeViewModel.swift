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
    @Published var showAlert = false
    @Published var selectedItem: Item?
    @Published var isLoading = false
    /// BarcodeScannerViewでISBNコードを読み取るとストリームを流すPublisher（値そのものを保持しない）
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    @Published var selection: TabItem = .scanner
    @Published var showItems = [Item]()
    
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
                apiService.request(ItemsRequest(query: query, useISBN: (self.selection == .scanner)))
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
                if self.selection == .scanner {
                    self.selectedItem = self.convertToItem(item: item)
                } else {
                    self.showItems = self.convertToItems(items: item)
                }
            }
        
        // ストリームが流れるとエラーアラートを出す
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                print(error)
                guard let self = self else {
                    return
                }
                self.isLoading = false
                self.alertItem = AlertContext.invalidURLSession
                self.showAlert = true
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
    
    private func convertToItems(items: [Items]) -> [Item] {
        return items.compactMap { (repo) -> Item in
            let formatter       = DateFormatter()
            formatter.locale    = Locale(identifier: "ja_JP")
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            
            let date = formatter.string(from: Date())
            let price = String(repo.itemPrice)
            
            return Item(
                author: repo.author,
                date: date,
                image: repo.largeImageUrl,
                link: repo.itemUrl,
                price: price,
                title: repo.title
            )
        }
    }
}

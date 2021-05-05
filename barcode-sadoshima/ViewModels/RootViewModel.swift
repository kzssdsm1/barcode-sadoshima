//
//  RootViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/03.
//

import SwiftUI
import Combine

final class RootViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var itemDetail: Item?
    @Published var isLoading = false
    /// BarcodeScannerViewでISBNコードを読み取るとストリームを流すPublisher（値そのものを保持しない）
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    @Published var selection: TabItem = .scanner
    @Published var searchResults = [Item]()
    
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
            .sink { [weak self] (items) in
                guard let self = self else {
                    return
                }
                
                if self.selection == .scanner {
                    self.itemDetail = nil
                    self.itemDetail = self.convertToItem(item: items[0])
                } else if self.selection == .search {
                    self.searchResults = []
                    for item in items {
                        if item.artistName == "" && item.label == "" {
                            self.searchResults.append(self.convertToItem(item: item))
                        }
                    }
                } else {
                    self.itemDetail = nil
                    self.searchResults = []
                }
                self.isLoading = false
            }
        
        // ストリームが流れるとエラーアラートを出す
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                guard let self = self else {
                    return
                }

                self.isLoading = false
                self.alertItem = AlertItem(title: error.errorTitle, message: error.errorDesc)
            })
        
        // ストリームを流し続けるとメモリリークを起こすためSubscribeを中止する
        cancellables += [
            responseSubscriber,
            errorSubscriber
        ]
    }

    private func convertToItem(item: Items) -> Item {
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let date = formatter.string(from: Date())
        
        let url = URL(string: item.largeImageUrl)
        
        let imageData: Data
        
        do {
            let data = try Data(contentsOf: url!)
            imageData = data
        } catch {
            imageData = UIImage(systemName: "questionmark.circle")!.jpegData(compressionQuality: 1)!
        }
        
        let price = String(item.itemPrice)
        
        return Item(
            author: item.author,
            caption: item.itemCaption,
            date: date,
            image: imageData,
            isbn: item.isbn,
            link: item.itemUrl,
            price: price,
            publisherName: item.publisherName,
            salesDate: item.salesDate,
            title: item.title
        )
    }
    
//    private func convertToItems(items: [Items]) -> [Item] {
//        return items.compactMap { (repo) -> Item in
//            let formatter       = DateFormatter()
//            formatter.locale    = Locale(identifier: "ja_JP")
//            formatter.dateStyle = .long
//            formatter.timeStyle = .none
//
//            let url = URL(string: repo.largeImageUrl)
//
//            let imageData: Data
//
//            do {
//                let data = try Data(contentsOf: url!)
//                imageData = data
//            } catch {
//                imageData = UIImage(systemName: "questionmark.circle")!.jpegData(compressionQuality: 1)!
//            }
//
//            let date = formatter.string(from: Date())
//            let price = String(repo.itemPrice)
//
//            return Item(
//                author: repo.author,
//                caption: repo.itemCaption,
//                date: date,
//                image: imageData,
//                isbn: repo.isbn,
//                link: repo.itemUrl,
//                price: price,
//                publisherName: repo.publisherName,
//                salesDate: repo.salesDate,
//                title: repo.title
//            )
//        }
//    }
}

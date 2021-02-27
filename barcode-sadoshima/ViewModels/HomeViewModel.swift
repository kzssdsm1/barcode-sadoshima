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
    @Published var selection = 0
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    
    private let apiService: APIServiceType
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    var titleString: String {
        if selection == 0 {
            return "バーコードスキャナー"
        } else if selection == 1 {
            return "お気に入りリスト"
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
                    .catch { [weak self] error -> Empty<ItemsResponse, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                    }
            }
            .map { $0.items }
            .sink { [weak self] (item) in
                guard let self = self else {
                    return
                }
                self.item = self.convertToItem(item: item)
            }
        
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                print(error)
                guard let self = self else {
                    return
                }
                self.alertItem = AlertContext.invalidURLSession
            })
        
        cancellables += [
            responseSubscriber,
            errorSubscriber
        ]
    }
    
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


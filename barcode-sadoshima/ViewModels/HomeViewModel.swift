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
    @Published var isSessionStart = true
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    @Published var productData = (author: "", title: "", image: "", price: "", link: "")
    
    private let apiService: APIServiceType
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
        
        bind()
    }
    
    func apply() {
        self.onCommitSubject.send("9784150312282")
    }
    
    private func bind() {
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
            }
        
        let showSheetSubscriber = onCommitSubject
            .map { _ in true }
            .assign(to: \.isShowSheet, on: self)
        
        let errorSubscriber = errorSubject
            .sink(receiveValue: { [weak self] (error) in
                print(error)
                guard let self = self else { return }
                self.alertItem = AlertContext.invalidURLSession
            })
        
        cancellables += [
            responseSubscriber,
            showSheetSubscriber,
            errorSubscriber
        ]
    }
}

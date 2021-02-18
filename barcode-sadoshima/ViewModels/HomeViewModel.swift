//
//  HomeViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/17.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var itemData: [ItemsResponse] = []
    @Published var alertItem: AlertItem?
    @Published var selection = 1
    @Published var onCommitSubject = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    var navigationBarTitle: String {
        if self.selection == 1 {
            return "バーコードスキャナー"
        } else if self.selection == 2 {
            return "お気に入りリスト"
        } else {
            return ""
        }
    }
    
    func fetchItem(query: String) {
        let request = ItemsRequest(query: query)
        NetworkPublisher.publish(request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("success")
                case let .failure(error):
                    print(error)
                    self.alertItem = AlertContext.invalidURLSession
                }
            }, receiveValue: { data in
                
            }).store(in: &cancellables)
    }
}


//
//  FavoriteListViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation
import Combine

final class FavoriteListViewModel: ObservableObject {
    struct Input {
        let title: String
        let author: String
        let image: String
        let price: String
        let link: String
        let date: String
    }
    
    @Published private(set) var itemsData: [Input] = []
    
    private var cancellables: Set<AnyCancellable> = []
    private let firebaseService = FirebaseService()
    
    init() {
        firebaseService.listener(id: firebaseService.userData!.uid)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] (item) in
                    guard let self = self else { return }
                    self.itemsData.append(self.convertInput(items: item))
                  }
            ).store(in: &cancellables)
    }
    
    private func convertInput(items: FirebaseDocument) -> Input {
        let formatter       = DateFormatter()
        formatter.locale    = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let date = formatter.string(from: items.createdAt)
        
        return Input(
            title: items.title,
            author: items.author,
            image: items.image,
            price: items.price,
            link: items.link,
            date: date)
    }
}


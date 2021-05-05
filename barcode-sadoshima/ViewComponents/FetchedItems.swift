//
//  FetchedItems.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/12.
//

import SwiftUI
import CoreData

struct FetchedItems<T, Content>: View where T: NSManagedObject, Content: View {
    private let content: ([T]) -> Content
    
    var request: FetchRequest<T>
    var items: FetchedResults<T> {
        request.wrappedValue
    }
    
    init(
        inputText: String,
        isAscending: Bool,
        sortKeyPath: ReferenceWritableKeyPath<FavoriteItem, String>,
        @ViewBuilder content: @escaping ([T]) -> Content
    ) {
        self.content = content
        
        if inputText == "" {
            self.request = FetchRequest(
                entity: FavoriteItem.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: sortKeyPath, ascending: isAscending)]
            )
        } else {
            self.request = FetchRequest(
                entity: FavoriteItem.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: sortKeyPath, ascending: isAscending)],
                predicate: NSPredicate(format: "title CONTAINS[C] %@ OR author CONTAINS[C] %@", inputText, inputText)
            )
        }
    }
    
    var body: some View {
        content(items.map { $0 })
    }
}

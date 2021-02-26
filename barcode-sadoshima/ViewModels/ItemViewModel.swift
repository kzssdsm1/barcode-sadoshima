//
//  ItemViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import Foundation
import CoreData

final class ItemViewModel: ObservableObject {
    @Published var existsItem = false
    
    private var context: NSManagedObjectContext?
    private var link: String?
    
    func setData(context: NSManagedObjectContext, link: String) {
        self.context = context
        self.link = link
        
        if searchItem(link) != nil {
            existsItem = true
        }
    }
    
    func addItem(item: Item) {
        guard let context = context else {
            return
        }
        let newItem = FavoriteItem(context: context)
        
        newItem.author = item.author
        newItem.date = item.date
        newItem.image = item.image
        newItem.link = item.link
        newItem.price = item.price
        newItem.title = item.title
        
        do {
            try context.save()
            existsItem = true
        } catch {
            fatalError()
        }
    }
    
    func removeItem() {
        guard let context = context else {
            return
        }
        guard let link = link else {
            return
        }
        guard let item = searchItem(link) else {
            return
        }
        
        let removeItem = item[0]
        
        context.delete(removeItem)
        
        do {
            try context.save()
            existsItem = false
        } catch {
            fatalError()
        }
    }
    
    private func searchItem(_ link: String) -> [FavoriteItem]? {
        guard let context = context else {
            return nil
        }
        
        let request = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        let predicate = NSPredicate(format: "link CONTAINS[C] %@", link)
        
        request.predicate = predicate
        
        do {
            return try context.fetch(request)
        } catch {
            fatalError()
        }
    }
}

//
//  FavoriteListViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/11.
//

import Foundation
import CoreData

final class FavoriteListViewModel: ObservableObject {
    @Published var removeItems = [String]()
    
    var context: NSManagedObjectContext?
    
    func removeItem() {
        guard let context = context else {
            return
        }
        removeItems.forEach { link in
            guard let item = searchItem(link) else {
                return
            }
            context.delete(item[0])
        }
        
        do {
            try context.save()
            removeItems = []
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

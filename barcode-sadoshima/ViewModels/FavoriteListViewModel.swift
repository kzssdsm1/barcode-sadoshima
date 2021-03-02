//
//  FavoriteListViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import Foundation
import CoreData

final class FavoriteListViewModel: ObservableObject {
    @Published var removeItemNum = [Int]()
    @Published var isShowAlert = false
    
    private var context: NSManagedObjectContext!
    
    func setData(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func removeItem() {
        guard let context = context else {
            return
        }
        
        removeItemNum.forEach { index in
            context.delete(fetchAllItem()[index])
        }
        
        do {
            try context.save()
            self.removeItemNum = []
        } catch {
            fatalError()
        }
    }
    
    private func fetchAllItem() -> [FavoriteItem] {
        let request = NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                request.sortDescriptors = [sortDescriptor]
        
        do {
            return try context!.fetch(request)
        } catch {
            return []
        }
    }
}

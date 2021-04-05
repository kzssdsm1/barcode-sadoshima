//
//  ItemViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import Foundation
import CoreData

final class ItemViewModel: ObservableObject {
    // 商品が既にお気に入りリストに登録されているかを判定する変数
    @Published var isItemExits = false
    
    private var context: NSManagedObjectContext?
    private var link: String?
    
    /// CoreDataの処理をで利用する環境値で設定されたcontextと商品掲載URLを受け取るメソッド
    /// - Parameters:
    ///   - context: コンテキスト
    ///   - link: 商品掲載URL
    func setData(context: NSManagedObjectContext, link: String) {
        self.context = context
        self.link = link
        
        // CoreData内に一致する商品があった場合はexistsItemをtrueにする
        if !(searchItem(link)!.isEmpty) {
            isItemExits = true
        }
    }
    
    /// 商品をお気に入りリストに登録するメソッド
    /// - Parameter item: 商品データ
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
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
            isItemExits = true
        } catch {
            fatalError()
        }
    }
    
    /// 商品をお気に入りリストから削除するメソッド
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
        
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
            isItemExits = false
        } catch {
            fatalError()
        }
    }
    
    /// 商品掲載URLが一致するデータをCoreDataで検索する関数
    /// - Parameter link: 親Viewから渡された商品検索URL
    /// - Returns: 検索結果を格納する配列
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

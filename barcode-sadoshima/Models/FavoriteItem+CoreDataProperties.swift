//
//  FavoriteItem+CoreDataProperties.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//
//

import Foundation
import CoreData


extension FavoriteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItem> {
        return NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
    }

    @NSManaged public var author: String
    @NSManaged public var date: String
    @NSManaged public var image: String
    @NSManaged public var link: String
    @NSManaged public var price: String
    @NSManaged public var title: String

}

extension FavoriteItem : Identifiable {

}

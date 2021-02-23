//
//  ProductViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class ProductViewModel: ObservableObject {
    @Published var isAddedData = false
    
    private var ref: DocumentReference? = nil
    
    private let db = Firestore.firestore().collection("items")
        
    func stateChange(uid: String, link: String) {
        let collection = db.document("\(uid)").collection("item")
        let query = collection.whereField("link", isEqualTo: link)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    if querySnapshot.documents.count == 0 {
                        self.isAddedData = false
                    } else {
                        self.isAddedData = true
                    }
                }
            }
        }
    }
    
    func add(author: String, title: String, image: String, price: String, link: String, uid: String) {
        let collection = db.document("\(uid)").collection("item")
        ref = collection.addDocument(data: [
            "author": author,
            "title": title,
            "image": image,
            "price": price,
            "link": link,
            "createdAt": FieldValue.serverTimestamp()
        ])
        stateChange(uid: uid, link: link)
    }
    
    func remove(uid: String, link: String) {
        let collection = db.document("\(uid)").collection("item")
        let query = collection.whereField("link", isEqualTo: link)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            } else {
                if let querySnapshot = querySnapshot {
                    if querySnapshot.documents.count == 0 {
                        print("Item does not exist")
                    } else {
                        for doc in querySnapshot.documents {
                            collection.document("\(doc.documentID)").delete()
                        }
                    }
                }
            }
        }
        self.isAddedData = false
    }
}

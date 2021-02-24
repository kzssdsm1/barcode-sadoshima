//
//  FavoriteListViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import Foundation
import Firebase
import FirebaseFirestore

final class FavoriteListViewModel: ObservableObject {
    @Published var itemsData = [DocumentModel]()
    @Published var productData = (author: "", title: "", image: "", price: "", link: "")
    
    private var ref: DocumentReference? = nil
    
    private var authState: FirebaseAuthStateObserver?
    private let db = Firestore.firestore()
    
    func listener(id: String) {
        db.collection("items").document("\(id)").collection("item").order(by: "createdAt", descending: true).addSnapshotListener() { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if let snapshot = snapshot {
                    snapshot.documentChanges.forEach { diff in
                        if diff.type == .added {
                            // 重複登録を防ぐためのif節
                            if !(self.itemsData.contains(where: { $0.link == (diff.document.data()["link"] as! String)})) {
                                guard let timeValue = diff.document.data(with: .estimate)["createdAt"] else {
                                    return
                                }
                                let timestamp = timeValue as! Timestamp
                                let date = timestamp.dateValue()
                                
                                let data = DocumentModel(
                                    id: diff.document.documentID,
                                    author: diff.document.data()["author"] as! String,
                                    title: diff.document.data()["title"] as! String,
                                    image: diff.document.data()["image"] as! String,
                                    price: diff.document.data()["price"] as! String,
                                    link: diff.document.data()["link"] as! String,
                                    createdAt: date
                                )
                                self.itemsData.append(data)
                            }
                        }
                        
                        if diff.type == .removed {
                            var removeIndex = 0
                            for index in self.itemsData.indices {
                                if self.itemsData[index].id == diff.document.documentID {
                                    removeIndex = index
                                }
                            }
                            self.itemsData.remove(at: removeIndex)
                        }
                    }
                }
            }
        }
    }
}

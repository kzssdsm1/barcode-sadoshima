//
//  FirebaseService.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/18.
//

import Foundation
import Combine
import Firebase
import FirebaseUI
import FirebaseFirestore

final class FirebaseService: NSObject, FUIAuthDelegate, ObservableObject {
    @Published var userData: FirebaseUser?
    
    private var ref: DocumentReference? = nil
    
    private let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func login(user: User?) {
        let doc = db.collection("users")
        
        if let user = user {
            let uid = user.uid
            let name = user.displayName!
            let photo = user.photoURL!
            
            DispatchQueue.main.async {
                let data = try? Data(contentsOf: photo)
                
                self.userData = FirebaseUser(
                    uid: uid,
                    name: name,
                    pohoto: data
                )
            }
            let query = doc.whereField("uid", isEqualTo: uid)
            
            query.getDocuments() { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    print("Error getting documents: \(String(describing: error))")
                    return
                }
                if querySnapshot.documents.count == 0 {
                    self.ref = doc.addDocument(data: [
                        "uid": uid,
                        "name": name,
                        "photo": photo
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        }  else {
                            print("Document added with ID: \(self.ref!.documentID)")
                        }
                    }
                } else {
                    print("Already registered")
                }
            }
        }
    }
    
    func listener(id: String) -> AnyPublisher<FirebaseDocument, Error> {
        let query = db.collection("items").document("\(id)").collection("item")
        return Future<FirebaseDocument, Error> { promise in
            query.addSnapshotListener() { (snapshot, err) in
                if let err = err {
                    promise(.failure(err))
                }
                if let snapshot = snapshot {
                    snapshot.documentChanges.forEach { diff in
                        if diff.type == .added {
                            let timestamp = diff.document.data(with: .estimate)["createdAt"] as! Timestamp
                            let createdAt = timestamp.dateValue()
                            let diffData = diff.document.data() as? Dictionary<String, String>
                            guard let data = diffData else {
                                return
                            }
                            let item = FirebaseDocument(author: data["author"]!,
                                                        title: data["title"]!,
                                                        image: data["image"]!,
                                                        price: data["price"]!,
                                                        link: data["data"]!,
                                                        createdAt: createdAt)
                            promise(.success(item))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

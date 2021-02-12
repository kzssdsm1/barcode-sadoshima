//
//  LoginViewController.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/12.
//

import UIKit
import Firebase
import FirebaseUI

final class LoginViewController: NSObject, FUIAuthDelegate {
    var userData: (name: String, photo: Data?, uid: String) = (name: "", photo: nil, uid: "")
    
    private var ref: DocumentReference? = nil
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    private func login(user: User?) {
        let usersRef = db.collection("users")
        
        if let user = user {
            let name = user.displayName
            let photo = user.photoURL
            let uid = user.uid
            
            let data = try? Data(contentsOf: photo!)
            self.userData = (name: name!, photo: data, uid: uid)
            
            let query = usersRef.whereField("uid", isEqualTo: uid)
            query.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if querySnapshot?.documents.count == 0 {
                        self.ref = usersRef.addDocument(data: ["name": "\(name!)", "photo": "\(photo!)", "uid": "\(uid)"])
                        { error in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                print("Document added with ID: \(self.ref!.documentID)")
                            }
                        }
                    }
                }
            }
        }
    }
}

//
//  LoginViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import Foundation
import Firebase
import FirebaseUI
import FirebaseFirestore

final class LoginViewModel: NSObject, FUIAuthDelegate, ObservableObject {
    private var ref: DocumentReference? = nil
    
    private var authState: FirebaseAuthStateObserver?
    private let db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    
    func setAuthState(authState: FirebaseAuthStateObserver) {
        self.authState = authState
    }
    
    private func login(user: User?) {
        let doc = db.collection("users")
        
        if let user = user {
            let uid = user.uid
            let name = user.displayName ?? "No Name"
            let photo = user.photoURL
            
            let query = doc.whereField("uid", isEqualTo: uid)
            query.getDocuments() { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot else {
                    print("Error getting documents: \(String(describing: error))")
                    return
                }
                if querySnapshot.documents.count == 0 {
                    self.ref = doc.addDocument(data: [
                        "uid": "\(uid)",
                        "name": "\(name)",
                        "photo": "\(photo!)"
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
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        print("デリゲート：\(String(describing: Auth.auth().currentUser?.displayName))")
        print(authDataResult as Any)
        if authDataResult == nil {
            print("キャンセル")
        } else {
            login(user: currentUser)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didFinish operation: FUIAccountSettingsOperationType, error: Error?) {}
}

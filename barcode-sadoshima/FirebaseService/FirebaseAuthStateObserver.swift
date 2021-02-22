//
//  FirebaseAuthStateObserver.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import Foundation
import Firebase

final class FirebaseAuthStateObserver: ObservableObject {
    @Published var isLogin = false
    @Published var userData: UserModel?
    
    private var listener: AuthStateDidChangeListenerHandle!
    
    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let data = try? Data(contentsOf: user.photoURL!)
                self.userData = UserModel(name: user.displayName ?? "No Name", uid: user.uid, photo: data!)
                self.isLogin = true
                print(self.userData ?? "No data")
            } else {
                self.userData = nil
                self.isLogin = false
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }
}

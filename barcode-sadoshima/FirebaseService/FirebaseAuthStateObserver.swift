//
//  FirebaseAuthStateObserver.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import Foundation
import Firebase

// ログイン状態の監視とユーザー情報の保持を行うクラス
final class FirebaseAuthStateObserver: ObservableObject {
    @Published var isLogin = false
    @Published var uid: String!
    
    private var listener: AuthStateDidChangeListenerHandle!
    
    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.uid = user.uid
                self.isLogin = true
            } else {
                self.isLogin = false
            }
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }
}

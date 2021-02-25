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
    // 値が存在しないタイミングでは読み込まない保証があるため強制アンラップ
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

//
//  AccountSettingView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import SwiftUI
import FirebaseUI

struct AccountSettingView: View {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    @State var isShowSheet = false
    
    private var stateDesc: String {
        switch authState.isLogin {
        case false:
            return "お気に入り登録機能はログイン後に使用可能になります"
        case true:
            return "現在ログイン中です"
        }
    }
    
    private var authButtonString: String {
        switch authState.isLogin {
        case false:
            return "ログイン"
        case true:
            return "ログアウト"
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()
                
                Text(stateDesc)
                    .foregroundColor(.black)
                    .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                    .padding()
                
                Button(action: {
                    if (authState.isLogin) {
                        try! Auth.auth().signOut()
                    } else {
                        isShowSheet = true
                    }
                }) {
                    Text(authButtonString)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: (geometry.size.width * 0.5), height: (geometry.size.height * 0.12))
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding()
                } // Button
                
                Spacer()
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        }
        .sheet(isPresented: $isShowSheet, onDismiss: { isShowSheet = false }) {
            LoginView()
        }
    }
}

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
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    private let screenHeight = CGFloat(UIScreen.main.bounds.height)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text(stateDesc)
                
                Spacer()
                
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
                        .frame(width: screenWidth * 0.4, height: screenHeight * 0.1)
                        .background(Color.blue)
                        .cornerRadius(25)
                }
            }
        }
        .sheet(isPresented: $isShowSheet, onDismiss: { isShowSheet = false }) {
            LoginView()
        }
    }
}

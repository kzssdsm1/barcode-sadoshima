//
//  LoginView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import SwiftUI
import FirebaseUI

struct LoginView: UIViewControllerRepresentable {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    @StateObject private var viewModel = LoginViewModel()
    
    final class Coordinator: NSObject, FUIAuthDelegate {
        let parent: LoginView
        
        init(parent: LoginView) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<LoginView>) -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self.viewModel
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        
        authUI.providers = providers
        
        return authUI.authViewController()
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<LoginView>) {}
}

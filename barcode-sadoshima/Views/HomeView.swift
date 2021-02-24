//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI
import Combine
import FirebaseUI

struct HomeView: View {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text(viewModel.titleString)
                        .font(.system(size: geometry.size.height * 0.04, weight: .heavy))
                        .padding()
                }
                
                TabView(selection: $viewModel.selection) {
                    if viewModel.isSessionStart == true {
                        BarcodeScannerView(isSessionStart: $viewModel.isSessionStart, onCommitSubject: $viewModel.onCommitSubject, alertItem: $viewModel.alertItem)
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(1)
                        // 強制的にViewの再描画を行いAVCaptureSessionを再開させる
                    } else if viewModel.isSessionStart == false {
                        Text("一時的にカメラは停止されます")
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(1)
                    }
                    if (authState.isLogin) {
                        FavoriteListView()
                            .tabItem{
                                Image(systemName: "star.fill")
                                Text("お気に入りリスト")
                            }
                            .tag(2)
                    } else if !(authState.isLogin) {
                        Text("お気に入りリストはログイン後に使用可能になります")
                            .tabItem {
                                Image(systemName: "star.fill")
                                Text("お気に入りリスト")
                            }
                            .tag(2)
                    }
                    
                    AccountSettingView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("アカウント")
                        }
                        .tag(3)
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowSheet, onDismiss: {
            viewModel.isSessionStart = true
            viewModel.isShowSheet = false
        }) {
            ProductView(productData: viewModel.productData)
        }
    }
}

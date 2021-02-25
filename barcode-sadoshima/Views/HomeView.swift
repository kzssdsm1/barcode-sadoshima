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
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Text(viewModel.titleString)
                    .foregroundColor(.black)
                    .font(.system(size: geometry.size.height * 0.04, weight: .heavy))
                    .padding((geometry.size.height * 0.02))
                
                TabView(selection: $viewModel.selection) {
                    if (viewModel.isSessionStart) {
                        // シミュレーター用
//                        Text("一時的にカメラは停止されます")
                        BarcodeScannerView(isSessionStart: $viewModel.isSessionStart, onCommitSubject: $viewModel.onCommitSubject, alertItem: $viewModel.alertItem)
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(1)
                        // 強制的にViewの再描画を行いAVCaptureSessionを再開させる
                    } else {
                        Text("一時的にカメラは停止されます")
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(1)
                    }
                    FavoriteListView()
                        .tabItem{
                            Image(systemName: "star.fill")
                            Text("お気に入りリスト")
                        }
                        .tag(2)
                    
                    
                    AccountSettingView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("アカウント")
                        }
                        .tag(3)
                }
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        }
        .sheet(isPresented: $viewModel.isShowSheet, onDismiss: {
            viewModel.isSessionStart = true
            viewModel.isShowSheet = false
        }) {
            ProductView(titleString: "検索結果", productData: viewModel.productData)
        }
    }
}

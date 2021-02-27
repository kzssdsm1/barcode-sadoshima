//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import SwiftUI
import Combine

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
                    if (viewModel.item == nil) {
                        // シミュレーター用
                        //                        Text("一時的にカメラは停止されます")
                        BarcodeScannerView(alertItem: $viewModel.alertItem, onCommitSubject: $viewModel.onCommitSubject)
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(0)
                        // 強制的にViewの再描画を行いAVCaptureSessionを再開させる
                    } else {
                        Text("一時的にカメラは停止されます")
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(0)
                    }
                    FavoriteListView(item: $viewModel.item)
                        .tabItem{
                            Image(systemName: "star.fill")
                            Text("お気に入りリスト")
                        }
                        .tag(1)
                }
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        }
        .sheet(item: $viewModel.item) { item in
            ProductView(titleString: "検索結果", item: item)
        }
    }
}

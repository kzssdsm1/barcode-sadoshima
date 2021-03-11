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
    @State private var reload = false
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if (viewModel.selection == 0) {
                    HStack {
                        Text("バーコードスキャナー")
                            .font(.system(size: CGFloat(geometry.size.height * 0.028), weight: .heavy))
                            .padding(CGFloat(geometry.size.height * 0.02))
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            reload.toggle()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.width * 0.08), height: CGFloat(geometry.size.height * 0.08))
                                .foregroundColor(.blue)
                                .padding(CGFloat(geometry.size.height * 0.02))
                        }
                    }
                    .frame(height: CGFloat(60))
                }
                
                TabView(selection: $viewModel.selection) {
                    // バーコードを検知した瞬間にお気に入りリストに移動するとAVCaptureSessionが止まったまま再開されないことがあるため
                    // ヘッダーのリロードボタンをタップすると強制的にBarcodeScannerViewを再描画させるように設定
                    if (viewModel.item == nil) {
                        if !(reload) {
                            BarcodeScannerView(alertItem: $viewModel.alertItem, onCommitSubject: $viewModel.onCommitSubject)
                                .tabItem {
                                    Image(systemName: "camera")
                                    Text("バーコードスキャナー")
                                }
                                .tag(0)
                        } else {
                            BarcodeScannerView(alertItem: $viewModel.alertItem, onCommitSubject: $viewModel.onCommitSubject)
                                .tabItem {
                                    Image(systemName: "camera")
                                    Text("バーコードスキャナー")
                                }
                                .tag(0)
                        }
                    } else {
                        Text("一時的にカメラは停止されます")
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(0)
                    }
                    FavoriteListView()
                        .tabItem{
                            Image(systemName: "star.fill")
                            Text("お気に入りリスト")
                        }
                        .tag(1)
                }
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(item: $viewModel.item) { item in
            ItemView(input: item, title: "検索結果")
        }
    }
}

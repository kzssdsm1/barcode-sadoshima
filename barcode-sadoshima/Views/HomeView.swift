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
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if (viewModel.selection == 0) {
                    HStack {
                        Text("バーコードスキャナー")
                            .foregroundColor(.black)
                            .font(.system(size: geometry.size.height * 0.03, weight: .heavy))
                            .padding((geometry.size.height * 0.02))
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            reload.toggle()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.height * 0.05), height: (geometry.size.width * 0.05))
                                .foregroundColor(.blue)
                                .padding((geometry.size.height * 0.02))
                        }
                    }
                }
                
                TabView(selection: $viewModel.selection) {
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
                    TextFieldView()
                        .tabItem{
                            Image(systemName: "star.fill")
                            Text("お気に入りリスト")
                        }
                        .tag(1)
                }
                .animation(.linear)
                .transition(.slide)
                .accentColor(.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        }
        .sheet(item: $viewModel.item) { item in
            ItemView(input: item, title: "検索結果")
        }
    }
}

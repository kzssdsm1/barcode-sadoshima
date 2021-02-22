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
                    } else if viewModel.isSessionStart == false {
                        Text("一時的にカメラは停止されます")
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(1)
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
        .sheet(isPresented: $viewModel.isShowSheet, onDismiss: { viewModel.isSessionStart = true }) {
            ProductView(productData: viewModel.productData)
        }
    }
}

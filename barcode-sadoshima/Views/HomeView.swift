//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    
    var body: some View {
        TabView {
            if viewModel.isSessionStart == true {
                BarcodeScannerView(isSessionStart: $viewModel.isSessionStart, onCommitSubject: $viewModel.onCommitSubject, alertItem: $viewModel.alertItem)
                    .tabItem {
                        Image(systemName: "camera")
                        Text("バーコードスキャナー")
                    }
            } else if viewModel.isSessionStart == false {
                Text("一時的にカメラは停止されます")
                    .tabItem {
                        Image(systemName: "camera")
                        Text("バーコードスキャナー")
                    }
            }
        }
        .sheet(isPresented: $viewModel.isShowSheet, onDismiss: { viewModel.isSessionStart = true }) {
            ProductView(productData: viewModel.productData)
        }
    }
}

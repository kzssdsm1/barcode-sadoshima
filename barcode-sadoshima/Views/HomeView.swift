//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/26.
//

import SwiftUI
import AVFoundation
import Combine

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    private let captureSession = AVCaptureSession()
    
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
                    }
                    .frame(height: CGFloat(60))
                }
                
                TabView(selection: $viewModel.selection) {
                    BarcodeScannerView(alertItem: $viewModel.alertItem, selection: $viewModel.selection, onCommitSubject: $viewModel.onCommitSubject, captureSession: captureSession)
                        .onAppear {
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
                        }
                        .onDisappear {
                            endSession()
                        }
                        .tabItem {
                            Image(systemName: "camera")
                            Text("バーコードスキャナー")
                        }
                        .tag(0)
                    
                    FavoriteListView(selection: $viewModel.selection)
                        .onAppear {
                            endSession()
                        }
                        .onDisappear {
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
                        }
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
                .onAppear {
                    endSession()
                }
                .onDisappear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        startSession()
                    }
                }
        }
    }
    private func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    private func endSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
}

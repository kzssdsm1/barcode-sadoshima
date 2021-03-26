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
    
    @State private var isAnimating = false
    
    private let captureSession = AVCaptureSession()
    private let animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    if (viewModel.selection == 0) {
                        HStack {
                            Text("バーコードスキャナー")
                                .font(.system(size: CGFloat(geometry.size.height * 0.028), weight: .heavy))
                                .padding(CGFloat(geometry.size.height * 0.02))
                            
                            Spacer(minLength: 0)
                        } // HStack
                        .frame(height: CGFloat(60))
                    }
                    
                    TabView(selection: $viewModel.selection) {
                        BarcodeScannerView(alertItem: $viewModel.alertItem, isLoading: $viewModel.isLoading, selection: $viewModel.selection, onCommitSubject: $viewModel.onCommitSubject, captureSession: captureSession)
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
                    } // TabView
                    .accentColor(.blue)
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if (viewModel.isLoading) {
                    ZStack {
                        // ①Loading中に画面をタップできないようにするためのほぼ透明なLayer
                        Color(.black)
                            .opacity(0.01)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.all)
                            .disabled(viewModel.isLoading)
                        Circle()
                            .trim(from: 0, to: 0.6)
                            .stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: .center),
                                    style: StrokeStyle(
                                        lineWidth: 8,
                                        lineCap: .round,
                                        dash: [0.1, 16],
                                        dashPhase: 8))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(self.isAnimating ? 360 : 0))
                            // ②アニメーションの実装
                            .onAppear() {
                                withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                                    self.isAnimating = true
                                }
                            }
                            .onDisappear() {
                                self.isAnimating = false
                            }
                    } // ZStack
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } // ZStack
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
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
                )
            )
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

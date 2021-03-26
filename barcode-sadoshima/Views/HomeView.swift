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
    
    @State private var isShowDesc = false
    @State private var isAnimating = false
    @State private var selection = 0
    
    private let captureSession = AVCaptureSession()
    private let animation = Animation.linear(duration: 1).repeatForever(autoreverses: false)
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    if (selection == 0) {
                        HStack {
                            Text("バーコードスキャナー")
                                .font(.system(size: CGFloat(geometry.size.height * 0.028), weight: .heavy))
                                .padding(CGFloat(geometry.size.height * 0.02))
                            
                            Spacer(minLength: 0)
                            
                            Button(action: {
                                isShowDesc = true
                                viewModel.isShowSheet = true
                            }) {
                                Text("使い方")
                                    .foregroundColor(.blue)
                                    .font(.system(size: CGFloat(geometry.size.height * 0.028), weight: .heavy))
                                    .padding(CGFloat(geometry.size.height * 0.02))
                            }
                        } // HStack
                        .frame(height: CGFloat(60))
                    }
                    
                    TabView(selection: $selection) {
                        BarcodeScannerView(alertItem: $viewModel.alertItem, isLoading: $viewModel.isLoading, selection: $selection, onCommitSubject: $viewModel.onCommitSubject, captureSession: captureSession)
                            .onAppear {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    startSession()
                                }
                            }
                            .onDisappear() {
                                endSession()
                            }
                            .tabItem {
                                Image(systemName: "camera")
                                Text("バーコードスキャナー")
                            }
                            .tag(0)
                        
                        FavoriteListView(selection: $selection)
                            .onAppear {
                                endSession()
                            }
                            .onDisappear() {
                                startSession()
                            }
                            .tabItem {
                                Image(systemName: "star.fill")
                                Text("お気に入りリスト")
                            }
                            .tag(1)
                    } // TabView
                    .accentColor(.blue)
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    firstVisitSetup()
                }
                
                if (viewModel.isLoading) {
                    ZStack {
                        Color(.black)
                            .opacity(0.01)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .edgesIgnoringSafeArea(.all)
                            .disabled(viewModel.isLoading)
                        
                        Color(.black)
                            .opacity(0.6)
                            .frame(width: 100, height: 100)
                            .cornerRadius(12)
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
        .sheet(isPresented: $viewModel.isShowSheet) {
            if (isShowDesc) {
                AppDescriptionView()
                    .onAppear {
                        endSession()
                    }
                    .onDisappear() {
                        isShowDesc = false
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
            } else {
                ItemView(input: viewModel.item!, title: "検索結果")
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
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert.init(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        if (selection == 0) {
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
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
    
    private func firstVisitSetup(){
        let visit = UserDefaults.standard.bool(forKey: CurrentUserDefaults.isFirstVisit)
        
        if visit {
            
        } else {
            isShowDesc = true
            viewModel.isShowSheet = true
            UserDefaults.standard.set(true, forKey: CurrentUserDefaults.isFirstVisit)
        }
    }
}

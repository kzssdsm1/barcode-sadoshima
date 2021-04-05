//
//  RootView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI
import Combine
import AVFoundation

struct RootView: View {
    @StateObject private var viewModel: RootViewModel = .init(apiService: APIService())
    
    @State private var captureSession = AVCaptureSession()
    @State private var isFirstTime = false
    @State private var isShowingKeyboard = false
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if viewModel.selection == .scanner {
                    HStack {
                        Text("バーコードスキャナー")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        
                        Spacer(minLength: 0)
                    } // HStack
                    .frame(height: 60)
                    .background(Color.offWhite.edgesIgnoringSafeArea(.all))
                }
                
                ZStack(alignment: .bottom) {
                    TabView {
                        ZStack {
                            BarcodeScannerView(
                                alertItem: $viewModel.alertItem,
                                captureSession: $captureSession,
                                isLoading: $viewModel.isLoading,
                                onCommitSubject: $viewModel.onCommitSubject
                            )
                            .hide(viewModel.selection != TabItem.scanner)
                            .opacity(viewModel.selection != TabItem.scanner ? 0 : 1)
                            
                            SearchView(
                                isLoading: $viewModel.isLoading,
                                isShowingKeyboard: $isShowingKeyboard,
                                itemDetail: $viewModel.itemDetail,
                                onCommitSubject: $viewModel.onCommitSubject,
                                searchResults: $viewModel.searchResults,
                                selection: $viewModel.selection
                            )
                            .hide(viewModel.selection != TabItem.search)
                            .opacity(viewModel.selection != TabItem.search ? 0 : 1)
                            
                            FavoriteListView(
                                isShowingKeyboard: $isShowingKeyboard,
                                itemDetail: $viewModel.itemDetail,
                                selection: $viewModel.selection
                            )
                            .hide(viewModel.selection != TabItem.favorite)
                            .opacity(viewModel.selection != TabItem.favorite ? 0 : 1)
                            
                            AppDescriptionView()
                                .hide(viewModel.selection != TabItem.usage)
                                .opacity(viewModel.selection != TabItem.usage ? 0 : 1)
                        } // ZStack
                        .edgesIgnoringSafeArea(.all)
                    } // TabView
                    
                    CustomTabBar(
                        captureSession: $captureSession,
                        isFirstTime: $isFirstTime,
                        selection: $viewModel.selection
                    )
                    .opacity(isShowingKeyboard ? 0 : 1)
                    .offset(y: isShowingKeyboard ? 100 : 0)
                } // ZStack
            } // VStack
            if viewModel.isLoading {
                LoadingIndicator()
            }
        } // ZStack
        .onAppear() {
            if !isFirstTime {
                DispatchQueue.global(qos: .userInitiated).async {
                    startSession()
                }
            }
        }
        .disabled(viewModel.isLoading)
        .sheet(item: $viewModel.itemDetail) { item in
            ItemView(input: item)
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        endSession()
                    }
                }
                .onDisappear() {
                    if viewModel.selection == .scanner {
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
                }
        } // sheet
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
        } // alert
    } // body
    
    private func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    private func endSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
}

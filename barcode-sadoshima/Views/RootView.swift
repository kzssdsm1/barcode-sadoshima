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
    @State private var needCameraUsage = false
    
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
                            .onAppear {
                                switch AVCaptureDevice.authorizationStatus(for: .video) {
                                case .notDetermined:
                                    AVCaptureDevice.requestAccess(for: .video) { granted in
                                        if granted {
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                startSession()
                                            }
                                        }
                                    }
                                case .restricted:
                                    needCameraUsage = true
                                case .denied:
                                    needCameraUsage = true
                                case .authorized:
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        startSession()
                                    }
                                @unknown default:
                                    viewModel.alertItem = AlertContext.unknownDeviceError
                                }
                            }
                            .onDisappear() {
                                DispatchQueue.global(qos: .userInitiated).async {
                                    endSession()
                                }
                            }
                            .hide(viewModel.selection != TabItem.scanner)
                            .opacity(viewModel.selection != TabItem.scanner ? 0 : 1)
                            .alert(isPresented: $needCameraUsage) {
                                Alert(
                                    title: Text("カメラの使用許可がありません"),
                                    message: Text("カメラの使用許可がない為バーコードの読み取りを開始できません。必要な場合は設定→書籍管理アプリよりカメラの使用の許可を行ってください"),
                                    primaryButton: .default(Text("設定へ"), action: {if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }}), secondaryButton: .cancel(Text("キャンセル")))
                            }
                            
                            SearchView(
                                alertItem: $viewModel.alertItem,
                                isLoading: $viewModel.isLoading,
                                itemDetail: $viewModel.itemDetail,
                                onCommitSubject: $viewModel.onCommitSubject,
                                searchResults: $viewModel.searchResults,
                                selection: $viewModel.selection
                            )
                            .hide(viewModel.selection != TabItem.search)
                            .opacity(viewModel.selection != TabItem.search ? 0 : 1)
                            
                            FavoriteListView(itemDetail: $viewModel.itemDetail, selection: $viewModel.selection)
                                .hide(viewModel.selection != TabItem.favorite)
                                .opacity(viewModel.selection != TabItem.favorite ? 0 : 1)
                            
                            AppDescriptionView()
                                .onDisappear() {
                                    if isFirstTime {
                                        isFirstTime = false
                                    }
                                }
                                .hide(viewModel.selection != TabItem.usage)
                                .opacity(viewModel.selection != TabItem.usage ? 0 : 1)
                        } // ZStack
                        .edgesIgnoringSafeArea(.all)
                    } // TabView
                    
                    CustomTabBar(selection: $viewModel.selection)
                } // ZStack
            } // VStack
            if viewModel.isLoading {
                LoadingIndicator()
            }
        } // ZStack
        .onAppear() {
            firstTimeSetup()
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
                        if viewModel.selection == .scanner {
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
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
    
    private func firstTimeSetup(){
        let userDefalutsKey = UserDefaults.standard.bool(forKey: CurrentUserDefaults.isFirstTime)
        
        if userDefalutsKey {
            isFirstTime = false
        } else {
            isFirstTime = true
            viewModel.selection = .usage
            UserDefaults.standard.set(true, forKey: CurrentUserDefaults.isFirstTime)
        }
    }
}

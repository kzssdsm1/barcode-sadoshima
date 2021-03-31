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
    @Binding var selection: TabItem
    @Binding var isEditing: Bool
    @Binding var isShowingKeyboard: Bool
    @Binding var showAlert: Bool
    @Binding var removeItems: [String]
    @Binding var selectedItem: Item?
    @Binding var alertItem: AlertItem?
    @Binding var isLoading: Bool
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    @Binding var captureSession: AVCaptureSession
    @Binding var isFirstTime: Bool
    @Binding var showItems: [Item]
    
    var body: some View {
        VStack(spacing: 0) {
            if selection == .スキャナー {
                HStack {
                    Text("バーコードスキャナー")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    Spacer(minLength: 0)
                }
                .frame(height: 60)
                
                BarcodeScannerView(
                    alertItem: $alertItem,
                    isLoading: $isLoading,
                    onCommitSubject: $onCommitSubject,
                    captureSession: $captureSession,
                    showAlert: $showAlert
                )
                .transition(.opacity)
                .onAppear {
                    if !isFirstTime {
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
                }
                .onDisappear() {
                    DispatchQueue.global(qos: .userInitiated).async {
                        endSession()
                    }
                }
            } else if selection == .検索 {
                SearchView(
                    isLoading: $isLoading,
                    onCommitSubject: $onCommitSubject,
                    showItems: $showItems,
                    selectedItem: $selectedItem,
                    selection: $selection,
                    isShowingKeyboard: $isShowingKeyboard
                )
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        endSession()
                        
                    }
                }
            } else if selection == .お気に入り {
                FavoriteListView(
                    isEditing: $isEditing,
                    isShowingKeyboard: $isShowingKeyboard,
                    showAlert: $showAlert,
                    removeItems: $removeItems,
                    selectedItem: $selectedItem,
                    selection: $selection
                )
                .transition(.opacity)
                .onAppear {
                    DispatchQueue.global(qos: .userInitiated).async {
                        endSession()
                    }
                }
            } else if selection == .使い方 {
                AppDescriptionView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            endSession()
                        }
                    }
                    .onDisappear() {
                        isFirstTime = false
                    }
            }
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

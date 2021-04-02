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
    @Binding var isShowingItems: Bool
    @Binding var isShowingFavoriteItems: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if selection == .scanner {
                HStack {
                    Text("バーコードスキャナー")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                    
                    Spacer(minLength: 0)
                }
                .frame(height: 60)
            }
            
            ZStack {
                BarcodeScannerView(
                    alertItem: $alertItem,
                    isLoading: $isLoading,
                    onCommitSubject: $onCommitSubject,
                    captureSession: $captureSession,
                    showAlert: $showAlert
                )
                .opacity(selection == .scanner ? 1 : 0)
                .onAppear {
                    if !isFirstTime {
                        DispatchQueue.global(qos: .userInitiated).async {
                            startSession()
                        }
                    }
                }
                
                SearchView(
                    isLoading: $isLoading,
                    onCommitSubject: $onCommitSubject,
                    showItems: $showItems,
                    selectedItem: $selectedItem,
                    selection: $selection,
                    isShowingKeyboard: $isShowingKeyboard,
                    isShowingItems: $isShowingItems
                )
                .opacity(selection == .search ? 1 : 0)
                
                FavoriteListView(
                    isEditing: $isEditing,
                    isShowingKeyboard: $isShowingKeyboard,
                    showAlert: $showAlert,
                    removeItems: $removeItems,
                    selectedItem: $selectedItem,
                    selection: $selection,
                    isShowingFavoriteItems: $isShowingFavoriteItems
                )
                .opacity(selection == .favorite ? 1 : 0)
                
                AppDescriptionView()
                    .opacity(selection == .usage ? 1 : 0)
            } // ZStack
            
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    } // body
    
    private func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
}

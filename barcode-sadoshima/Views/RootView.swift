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
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
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
                } else if selection == .お気に入り {
                    FavoriteListView(
                        isEditing: $isEditing,
                        isShowingKeyboard: $isShowingKeyboard,
                        showAlert: $showAlert,
                        removeItems: $removeItems,
                        selectedItem: $selectedItem
                    )
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            endSession()
                        }
                    }
                } else if selection == .使い方 {
                    AppDescriptionView()
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
            
            if isLoading {
                ZStack {
                    Color(.black)
                        .opacity(0.6)
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                        .disabled(isLoading)
                    
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
            }
        } // ZStack
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

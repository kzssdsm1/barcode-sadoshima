//
//  MotionTabBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI
import AVFoundation

struct MotionTabBar: View {
    @State private var tappedItemMidX: CGFloat = 0
    @Binding var selection: TabItem
    @Binding var isFirstTime: Bool
    @Binding var captureSession: AVCaptureSession
    @Binding var isEditing: Bool
    @Binding var isShowingItems: Bool
    @Binding var isShowingFavoriteItems: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { item in
                GeometryReader { proxy in
                    Button(action: {
                        withAnimation(
                            .interactiveSpring(
                                response: 0.4,
                                dampingFraction: 0.5
                            )
                        ) {
                            tappedItemMidX = proxy.frame(in: .global).midX
                            
                            if item == .scanner {
                                isFirstTime = false
                                isShowingItems = false
                                isShowingFavoriteItems = false
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    startSession()
                                }
                            } else if item == .search {
                                isFirstTime = false
                                isShowingFavoriteItems = false
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    endSession()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        isShowingItems = true
                                    }
                                }
                            } else if item == .favorite {
                                isFirstTime = false
                                isShowingItems = false
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    endSession()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                        isShowingFavoriteItems = true
                                    }
                                }
                            } else if item == .usage {
                                isShowingItems = false
                                isShowingFavoriteItems = false
                                
                                DispatchQueue.global(qos: .userInitiated).async {
                                    endSession()
                                }
                            }
                            
                            selection = item
                        }
                    }, label: {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                TabBarButton(
                                    imageName: item.imageName,
                                    buttonColor: selection == item ? item.buttonColor : .gray,
                                    proxy: proxy
                                )
                            )
                            .background(
                                Text(item.buttonText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selection == item ? item.buttonColor : .gray)
                                    .offset(y: 15)
                            )
                    }) // Button
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .onAppear {
                        if isFirstTime {
                            if item == TabItem.allCases[3] {
                                tappedItemMidX = proxy.frame(in: .global).midX
                            }
                        } else {
                            if item == TabItem.allCases.first {
                                tappedItemMidX = proxy.frame(in: .global).midX
                            }
                        }
                    } // onAppear
                } // GeometryReader
            } // ForEach
        } // HStack
        .frame(height: 60)
        .background(
            Color.white
                .clipShape(TabBarShape(tappedItemMidX: tappedItemMidX))
                .edgesIgnoringSafeArea(.all)
                .cornerRadius(20)
                .shadow(
                    color: .gray,
                    radius: 1, x: 0, y: 5
                )
        )
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


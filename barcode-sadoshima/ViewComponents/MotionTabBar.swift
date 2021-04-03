//
//  MotionTabBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/02.
//

import SwiftUI
import AVFoundation

struct MotionTabBar: View {
    @Binding var selection: TabItem
    @Binding var isFirstTime: Bool
    @Binding var captureSession: AVCaptureSession
    @Binding var isEditing: Bool
    @Binding var selectedItem: Item?
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { item in
                GeometryReader { proxy in
                    Button(action: {
                        if item == .scanner {
                            selectedItem = nil
                            isFirstTime = false
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                startSession()
                            }
                        } else if item == .search {
                            selectedItem = nil
                            isFirstTime = false
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                endSession()
                            }
                        } else if item == .favorite {
                            selectedItem = nil
                            isFirstTime = false
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                endSession()
                            }
                        } else if item == .usage {
                            selectedItem = nil
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                endSession()
                            }
                        }
                        
                        selection = item
                    }, label: {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                TabBarButton(
                                    imageName: item.imageName,
                                    buttonColor: selection == item ? item.buttonColor.opacity(0.8) : .gray,
                                    proxy: proxy
                                )
                            )
                            .background(
                                Text(item.buttonText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selection == item ? item.buttonColor.opacity(0.8) : .gray)
                                    .offset(y: 15)
                            )
                    }) // Button
                    .frame(width: proxy.size.width, height: proxy.size.height)
                } // GeometryReader
            } // ForEach
        } // HStack
        .frame(width: screenWidth - 20, height: 60)
        .background(
            Group {
                if selection == .scanner {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(width: screenWidth - 20, height: 60)
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(width: screenWidth - 20, height: 60)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                }
            }
            
        )
        .padding([.bottom, .horizontal], 10)
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


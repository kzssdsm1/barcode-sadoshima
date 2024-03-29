//
//  CustomTabBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/03.
//

import SwiftUI
import AVFoundation

struct CustomTabBar: View {
    @Binding var selection: TabItem
    
    @State private var isShowingKeyboard = false
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { item in
                GeometryReader { proxy in
                    Button(action: {
                        selection = item
                    }, label: {
                        Rectangle()
                            .foregroundColor(.clear)
                            .overlay(
                                TabBarButton(
                                    buttonColor: selection == item ? item.buttonColor.opacity(0.8) : .gray,
                                    imageName: item.imageName,
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
        .opacity(isShowingKeyboard ? 0 : 1)
        .offset(y: isShowingKeyboard ? 100 : 0)
        .padding([.bottom, .horizontal], 10)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            withAnimation(.linear(duration: 0.2)) {
                isShowingKeyboard = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            withAnimation(.linear(duration: 0.2)) {
                isShowingKeyboard = false 
            }
        }
    } // body
}



//
//  MotionTabBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct MotionTabBar: View {
    @State private var tappedItemMidX: CGFloat = 0
    @Binding var selection: TabItem
    @Binding var isFirstTime: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { item in
                GeometryReader { proxy in
                    Button(action: {
                        withAnimation(
                            .interactiveSpring(
                                response: 0.5, dampingFraction: 0.5, blendDuration: 0.5
                            )
                        ) {
                            tappedItemMidX = proxy.frame(in: .global).midX
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
                                Text(item.rawValue.uppercased())
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selection == item ? item.buttonColor : .gray)
                                    .offset(y: 15)
                            )
                    }) // Button
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .onAppear {
                        if isFirstTime {
                            if item == TabItem.allCases[2] {
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
}


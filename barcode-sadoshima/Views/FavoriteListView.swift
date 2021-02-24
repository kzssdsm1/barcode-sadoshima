//
//  FavoriteListView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/22.
//

import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    @StateObject private var viewModel = FavoriteListViewModel()
    
    @State private var isShowSheet = false
    
    var body: some View {
        GeometryReader { geometry in
            if (authState.isLogin) {
                if !(viewModel.itemsData.isEmpty) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center) {
                            if (authState.isLogin) {
                                ForEach(viewModel.itemsData) { input in
                                    Button(action: {
                                        showSheet(input: input)
                                    }) {
                                        CardView(input: input)
                                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.24)
                                            .padding()
                                    }
                                }
                            }
                        } // VStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } // ScrollView
                    .background(Color.white.ignoresSafeArea(.all, edges: .all))
                } else {
                    VStack(alignment: .center) {
                        Spacer()
                        
                        Text("お気に入りリストに登録された商品がありません")
                            .foregroundColor(.black)
                            .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.ignoresSafeArea(.all, edges: .all))
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    
                    Text("お気に入りリストはログイン後に使用可能になります")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.03, weight: .medium))
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.ignoresSafeArea(.all, edges: .all))
            }
        }.onAppear() {
            // ログアウトを行った際にアプリが落ちるのを防ぐためのif節
            if (authState.isLogin) {
                viewModel.listener(id: authState.uid)
            }
        }
        .sheet(isPresented: $isShowSheet, onDismiss: {
                isShowSheet = false }) {
            ProductView(titleString: "詳細" ,productData: viewModel.productData)
        }
    }
    
    private func showSheet(input: DocumentModel) {
        viewModel.productData = (author: input.author, title: input.title, image: input.image, price: input.price, link: input.link)
        isShowSheet = true
    }
}

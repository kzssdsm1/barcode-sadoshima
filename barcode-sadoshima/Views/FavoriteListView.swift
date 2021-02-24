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
            ZStack(alignment: .center) {
                ScrollView(showsIndicators: false) {
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
            }
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        }.onAppear() {
            // ログアウトを行った際にアプリが落ちるのを防ぐためのif節
            if (authState.isLogin) {
                viewModel.listener(id: authState.userData?.uid ?? "")
            }
        }
        .sheet(isPresented: $isShowSheet, onDismiss: {
            isShowSheet = false }) {
            ProductView(productData: viewModel.productData)
        }
    }
    
    private func showSheet(input: DocumentModel) {
        viewModel.productData = (author: input.author, title: input.title, image: input.image, price: input.price, link: input.link)
        isShowSheet = true
    }
}

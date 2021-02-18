//
//  HomeView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/17.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $viewModel.selection) {
                BarcodeScannerView()
                    .tabItem {
                        Image(systemName: "camera")
                        Text("バーコードスキャナー")
                    }
                    .tag(1)
                FavoriteListView()
                    .tabItem {
                        Image(systemName: "star.fill")
                        Text("お気に入りリスト")
                    }
                    .tag(2)
            }
            .navigationBarTitle(viewModel.navigationBarTitle)
        }
    }
}

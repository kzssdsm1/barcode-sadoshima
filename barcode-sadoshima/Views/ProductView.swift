//
//  ProductView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var authState: FirebaseAuthStateObserver
    
    @StateObject var viewModel = ProductViewModel()
    
    @State var isShowAlert = false
    
    var titleString: String
    var productData: (author: String, title: String, image: String, price: String, link: String)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Text(titleString)
                    .font(.system(size: (geometry.size.height * 0.04), weight: .heavy))
                    .foregroundColor(.black)
                    .padding()
                
                if let url = URL(string: productData.image) {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (geometry.size.width * 0.6), height: (geometry.size.height * 0.45))
                                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                                .padding()
                        }
                    }
                }
                
                Text(productData.title)
                    .font(.system(size: (geometry.size.height * 0.02), weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding((geometry.size.height * 0.015))
                
                Text("著者: \(productData.author)")
                    .font(.system(size: (geometry.size.height * 0.02), weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding((geometry.size.height * 0.015))
                
                Text("値段: \(productData.price)円")
                    .font(.system(size: (geometry.size.height * 0.02), weight: .medium))
                    .foregroundColor(.black)
                    .padding((geometry.size.height * 0.015))
                
                Button(action: {
                    let url = URL(string: productData.link)
                    UIApplication.shared.open(url!)
                }, label: {
                    Text("Safariで商品ページを開く")
                        .font(.system(size: (geometry.size.height * 0.02), weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: (geometry.size.width * 0.45), height:(geometry.size.height * 0.08))
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding((geometry.size.height * 0.012))
                })
                
                if (authState.isLogin) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            if (viewModel.isAddedData) {
                                isShowAlert = true
                            } else {
                                viewModel.add(
                                    author: productData.author,
                                    title: productData.title,
                                    image: productData.image,
                                    price: productData.price,
                                    link: productData.link,
                                    uid: authState.uid
                                )
                            }
                        }, label: {
                            Image(systemName: "star.fill")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: (geometry.size.width * 0.13), height: (geometry.size.height * 0.15))
                                .foregroundColor((viewModel.isAddedData) ? .yellow : .gray)
                                .opacity((viewModel.isAddedData) ? 1.0 : 0.7)
                                .padding((geometry.size.height * 0.015))
                        })
                    } // HStack
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        } // GeometryReader
        .onAppear() {
            if (authState.isLogin) {
                viewModel.stateChange(uid: authState.uid, link: productData.link)
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("削除"),
                message: Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除")) {
                    viewModel.remove(uid: authState.uid, link: productData.link)
                })
        }
    }
}

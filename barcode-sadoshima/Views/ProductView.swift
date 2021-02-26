//
//  ProductView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI

struct ProductView: View {
    
    @EnvironmentObject private var authState: FirebaseAuthStateObserver
    
    @StateObject private var viewModel = ProductViewModel()
    
    @State private var isShowAlert = false
    
    var titleString: String
    var productData: (author: String, title: String, image: String, price: String, link: String)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                Text(titleString)
                    .font(.system(size: (geometry.size.height * 0.04), weight: .heavy))
                    .foregroundColor(.black)
                    .padding((geometry.size.height * 0.02))
                
                if let image = convertStringToUIImage(url: productData.image) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: (geometry.size.width * 0.6), height: (geometry.size.height * 0.45))
                        .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        .padding((geometry.size.height * 0.02))
                } else {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: (geometry.size.width * 0.6), height: (geometry.size.height * 0.45))
                        .padding((geometry.size.height * 0.02))
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
                        .frame(width: (geometry.size.width * 0.5), height:(geometry.size.height * 0.08))
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(EdgeInsets(
                                    top: (geometry.size.height * 0.012),
                                    leading: (geometry.size.height * 0.012),
                                    bottom: (geometry.size.height * 0),
                                    trailing: (geometry.size.height * 0.012)))
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
                                .padding(EdgeInsets(
                                            top: (geometry.size.height * 0.005),
                                            leading: (geometry.size.height * 0.015),
                                            bottom: (geometry.size.height * 0.015),
                                            trailing: (geometry.size.height * 0.037)))
                        })
                    } // HStack
                }
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea(.all, edges: .all))
        } // GeometryReader
        .onAppear() {
            // アプリが落ちるのを防ぐためのif節
            if (authState.isLogin) {
                // Firestoreに既にデータが存在するかどうかを判定する
                viewModel.setState(uid: authState.uid, link: productData.link)
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
    
    // String型のURLをUIImageに変換する関数
    private func convertStringToUIImage(url: String) -> UIImage? {
        guard let url = URL(string: url) else {
            return nil
        }
        let data = try! Data(contentsOf: url)
        
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return uiImage
    }
}

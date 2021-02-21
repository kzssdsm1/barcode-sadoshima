//
//  ProductView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI

struct ProductView: View {
    var productData: (author: String, title: String, image: String, price: String, link: String)
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    private let screenHeight = CGFloat(UIScreen.main.bounds.height)
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            if let url = URL(string: productData.image) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: screenWidth * 0.75,
                                   height: screenHeight * 0.5,
                                   alignment: .center)
                    }
                }
            }
            
            Text(productData.title)
                .padding()
            
            Text("著者: \(productData.author)")
                .padding()
            
            Text("値段: \(productData.price)円")
                .padding()
            
            Button(action: {
                let url = URL(string: productData.link)
                UIApplication.shared.open(url!)
            }, label: {
                Text("Safariで商品ページを開く")
            })
        }
    }
}

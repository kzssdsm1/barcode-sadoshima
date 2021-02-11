//
//  ProductView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/11.
//

import SwiftUI
import Alamofire

struct ProductView: View {
    
    @Binding var title: String
    @Binding var author: String
    @Binding var price: String
    @Binding var link: String
    @Binding var imageData: Data?
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    private let screenHeight = CGFloat(UIScreen.main.bounds.height)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Spacer()
                
                if let itemImage = imageData {
                    if let image = UIImage(data:itemImage) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: screenWidth * 0.75,
                                   height: screenHeight * 0.5,
                                   alignment: .center)
                    }
                }
                Text(title)
                    .padding()
                
                Text("著者: \(author)")
                    .padding()
                
                Text("値段: \(price)円")
                    .padding()
                
                Button(action: {
                    let url = URL(string: link)
                    UIApplication.shared.open(url!)
                }, label: {
                    Text("Safariで商品ページを開く")
                })
            }
        }
    }
}


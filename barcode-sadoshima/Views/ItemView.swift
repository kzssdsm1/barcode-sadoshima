//
//  ItemView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/27.
//

import SwiftUI

struct ItemView: View {
    @Environment(\.managedObjectContext) private var context
    
    @StateObject private var viewModel = ItemViewModel()
    
    @State private var isShowAlert = false
    
    let input: Item
    let title: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    
                    
                    Text(title)
                        .foregroundColor(.black)
                        .font(.system(size: (geometry.size.height * 0.05), weight: .heavy))
                        .padding((geometry.size.height * 0.04))
                    
                    Spacer()
                }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment:  .leading, spacing: 0) {
                        HStack {
                            Spacer()
                            
                            if let image = convertStringToUIImage(url: input.image) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 135, height: 200)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                                    .padding([.bottom, .horizontal], (geometry.size.height * 0.04))
                            } else {
                                // 何らかの理由により画像データを取得できなかった時は代理の画像を表示する
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 135, height: 200)
                                    .padding([.bottom, .horizontal], (geometry.size.height * 0.04))
                            }
                            
                            Spacer()
                        }
                        
                        Text("タイトル：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: (geometry.size.height * 0.02), weight: .regular))
                            .padding(.horizontal, (geometry.size.height * 0.04))
                        
                        Text(input.title)
                            .foregroundColor(.black)
                            .font(.system(size: (geometry.size.height * 0.03), weight: .semibold))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.bottom, .horizontal], (geometry.size.height * 0.04))
                        
                        Text("著者：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: (geometry.size.height * 0.02), weight: .regular))
                            .padding(.horizontal, (geometry.size.height * 0.04))
                        
                        Text(input.author)
                            .foregroundColor(.black)
                            .font(.system(size: (geometry.size.height * 0.03), weight: .semibold))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.bottom, .horizontal], (geometry.size.height * 0.04))
                        
                        Text("値段：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: (geometry.size.height * 0.02), weight: .regular))
                            .padding(.horizontal, (geometry.size.height * 0.04))
                        
                        Text("\(input.price)円")
                            .foregroundColor(.black)
                            .font(.system(size: (geometry.size.height * 0.03), weight: .semibold))
                            .padding([.bottom, .horizontal], (geometry.size.height * 0.04))
                        
                        HStack {
                            Button(action: {
                                let url = URL(string: input.link)
                                UIApplication.shared.open(url!)
                            }, label: {
                                Text("Safariで商品ページを開く")
                                    .font(.system(size: (geometry.size.height * 0.02), weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(width: (geometry.size.width * 0.5), height:(geometry.size.height * 0.08))
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }) // Button
                            
                            Spacer()
                            
                            Button(action: {
                                if (viewModel.existsItem) {
                                    isShowAlert = true
                                } else {
                                    viewModel.addItem(item: input)
                                }
                            }, label: {
                                Image(systemName: "star.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: (geometry.size.width * 0.15), height: (geometry.size.height * 0.15))
                                    .foregroundColor((viewModel.existsItem) ? .yellow : .gray)
                                    .opacity((viewModel.existsItem) ? 1.0 : 0.7)
                            }) // Button
                        } // HStack
                        .padding(.horizontal, (geometry.size.height * 0.06))
                    } // VStack
                } // ScrollView
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.edgesIgnoringSafeArea(.bottom))
        } // GeometryReader
        .onAppear() {
            viewModel.setData(context: context, link: input.link)
        } // .onAppear
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("削除"),
                message: Text("お気に入りリストからこの商品を削除しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("削除")) {
                    viewModel.removeItem()
                })
        } // .alert
    } // body
    
    /// String型のURLからUIImageを取り出す関数
    /// - Parameter url: 親Viewから渡された書籍の画像URL
    /// - Returns: 画像URLから変換されたUIImage
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

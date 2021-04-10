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
    
    @State private var isShowingAlert = false
    
    let input: Item
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Text("書籍情報")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.gray)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment:  .leading, spacing: 0) {
                        HStack {
                            Spacer()
                            
                            if let image = convertStringToUIImage(data: input.image) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 135, height: 200)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.offWhite)
                                            .frame(width: 170, height: 230)
                                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                    )
                            } else {
                                // 何らかの理由により画像データを取得できなかった時は代理の画像を表示する
                                Image(systemName: "questionmark.circle")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 135, height: 200)
                                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.offWhite)
                                            .frame(width: 170, height: 230)
                                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                                    )
                            }
                            
                            Spacer()
                        } // HStack
                        .frame(height: 270)
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                        
                        Text("タイトル：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: 18, weight: .regular))
                        
                        Text(input.title)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 20)
                        
                        Text("著者：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: 18, weight: .regular))
                        
                        Text(input.author)
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 20)
                        
                        Text("値段：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: 18, weight: .regular))
                        
                        Text("\(input.price)円")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 20)
                        
                        HStack {
                            Button(action: {
                                let url = URL(string: input.link)
                                UIApplication.shared.open(url!)
                            }, label: {
                                Text("Safariで商品ページを開く")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.gray)
                            }) // Button
                            .buttonStyle(CustomRoundedRectangleButtonStyle())
                            .frame(width: 200, height: 80)
                            
                            Spacer(minLength: 20)
                            
                            Button(action: {
                                if (viewModel.isItemExits) {
                                    isShowingAlert = true
                                } else {
                                    viewModel.addItem(item: input)
                                }
                            }, label: {
                                Image(systemName: "star.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor((viewModel.isItemExits) ? .gold : .gray)
                                    .opacity((viewModel.isItemExits) ? 1.0 : 0.7)
                            }) // Button
                            .buttonStyle(CustomButtonStyle())
                            .frame(width: 80, height: 80)
                        } // HStack
                        .padding(.horizontal, 15)
                        .padding(.bottom, 30)
                    } // VStack
                } // ScrollView
            } // VStack
            .padding(20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.offWhite.edgesIgnoringSafeArea(.all))
        } // GeometryReader
        .onAppear() {
            viewModel.setData(context: context, link: input.link)
        } // .onAppear
        .alert(isPresented: $isShowingAlert) {
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
    private func convertStringToUIImage(data: Data) -> UIImage? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return uiImage
    }
}

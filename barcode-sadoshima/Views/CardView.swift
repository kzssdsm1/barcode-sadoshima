//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct CardView: View {
    let input: Item
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    
                    if let image = convertStringToUIImage(url: input.image) {
                        Image(uiImage: image)
                            // Buttonで包んだ際に色が変わらないようにするため
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: (geometry.size.width * 0.2), minHeight: (geometry.size.height * 0.3))
                            .frame(maxWidth: 135, maxHeight: 200)
                            .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    } else {
                        // 何らかの理由により画像データを取得できなかった時は代理の画像を表示する
                        Image(systemName: "questionmark.circle")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: (geometry.size.width * 0.2), minHeight: (geometry.size.height * 0.3))
                            .frame(maxWidth: 135, maxHeight: 200)
                    }
                    
                    Spacer()
                } // HStack
                .padding(.bottom, (geometry.size.height * 0.04))
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("タイトル：")
                            // 明示的に文字色を定義しておかないとButtonで包んだ際におかしくなる
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: (geometry.size.height * 0.03), weight: .regular))
                        
                        Text(input.title)
                            .foregroundColor(.black)
                            .font(.system(size: (geometry.size.height * 0.05), weight: .semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer(minLength: 0)
                            .frame(maxHeight: (geometry.size.height * 0.08))
                        
                        Text("追加日時：")
                            .foregroundColor(.gray)
                            .opacity(0.9)
                            .font(.system(size: (geometry.size.height * 0.03), weight: .regular))
                        
                        Text(input.date)
                            .foregroundColor(.black)
                            .font(.system(size: (geometry.size.height * 0.05), weight: .semibold))
                    } // VStack
                    .layoutPriority(100)
                } // HStack
            } // VStack
            .padding(EdgeInsets(
                        top: (geometry.size.height * 0.06),
                        leading: (geometry.size.height * 0.06),
                        bottom: (geometry.size.height * 0.06),
                        trailing: (geometry.size.height * 0.06)))
        } // GeometryReader
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

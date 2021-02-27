//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI

struct CardView: View {
    let input: Item
    
    init(input: Item) {
        self.input = input
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if let image = convertStringToUIImage(url: input.image) {
                    Image(uiImage: image)
                        // Buttonで包んだ際に色が変わらないようにするため
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.23, height: geometry.size.height * 0.8)
                        .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        .padding(EdgeInsets(
                                    top: (geometry.size.height * 0.015),
                                    leading: (geometry.size.height * 0.020),
                                    bottom: (geometry.size.height * 0.008),
                                    trailing: (geometry.size.height * 0.015)))
                } else {
                    Image(systemName: "questionmark.circle")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.23, height: geometry.size.height * 0.8)
                        .padding(EdgeInsets(
                                    top: (geometry.size.height * 0.015),
                                    leading: (geometry.size.height * 0.020),
                                    bottom: 0,
                                    trailing: (geometry.size.height * 0.015)))
                }
                
                
                VStack(alignment: .leading) {
                    Text(input.title)
                        // 明示的に色を定義しておかないとButton等で包んだ時におかしくなる(バグ？)
                        .foregroundColor(.black)
                        // 文字数によっては位置が大幅にずれてしまうため文字数によってサイズを変更する(周囲の余白を取得して再計算させられるなら多分そっちの方がいいけどやり方がさっぱりわからない)
                        .font(.system(size: input.title.count < 10 ? geometry.size.height * 0.14 : geometry.size.height * 0.12, weight: .bold))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("登録日時: \(input.date)")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.10, weight: .semibold))
                        .padding(EdgeInsets(
                                    top: (geometry.size.height * 0.05),
                                    leading: 0,
                                    bottom: 0,
                                    trailing: (geometry.size.height * 0.1)))
                }
            }
        }
        .padding(15)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
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

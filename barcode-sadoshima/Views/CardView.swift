//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/24.
//

import SwiftUI

struct CardView: View {
    let input: DocumentModel
    
    init(input: DocumentModel) {
        self.input = input
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if let url = URL(string: input.image) {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            Image(uiImage: image)
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
                        }
                    }
                }
                VStack {
                    Text(input.title)
                        // 明示的に色を定義しておかないとButton等で包んだ時に色がおかしくなる(バグ？)
                        .foregroundColor(.black)
                        // 文字数によっては位置が大幅にずれてしまうため文字数によってサイズを変更する(周囲の余白を取得して再計算させられるなら多分そっちの方がいいけどやり方がさっぱりわからない)
                        .font(.system(size: input.title.count < 10 ? geometry.size.height * 0.14 : geometry.size.height * 0.12, weight: .bold))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("登録日時: \(convertDateToString(date: input.createdAt))")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.10, weight: .semibold))
                        .padding(EdgeInsets(
                                    top: (geometry.size.height * 0.05),
                                    leading: (geometry.size.height * 0.2),
                                    bottom: (geometry.size.height * 0.1),
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
    
    // Date型をString型に変換するメソッド
    private func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let dateString = formatter.string(from: date)
        return dateString
    }
}

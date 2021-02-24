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
                        }
                    }
                }
                VStack {
                    Text(input.title)
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.15, weight: .bold))
                    
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                    
                    Text("登録日時: \(convertDateToString(date: input.createdAt))")
                        .foregroundColor(.black)
                        .font(.system(size: geometry.size.height * 0.12, weight: .semibold))
                }
            }
        }
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
    
    private func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let dateString = formatter.string(from: date)
        return dateString
    }
}

//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/12.
//

import SwiftUI

struct CardView: View {
    @Binding var selection: TabItem
    
    let input: Item
    
    var body: some View {
        HStack(spacing: 0) {
            if let image = convertDataToUIImage(data: input.image) {
                Image(uiImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 110)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.offWhite)
                            .frame(width: 80, height: 120)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
            } else {
                Image(systemName: "questionmark.circle")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 110)
                    .shadow(color: .gray, radius: 1, x: 0, y: 0)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.offWhite)
                            .frame(width: 80, height: 120)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
            }
            
            VStack(alignment: .leading) {
                Text("タイトル：")
                    .foregroundColor(.gray)
                    .opacity(0.9)
                    .font(.system(size: 12, weight: .regular))
                
                Text(input.title)
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer(minLength: 0)
                
                if selection == .favorite {
                    Text("追加日時：")
                        .foregroundColor(.gray)
                        .opacity(0.9)
                        .font(.system(size: 12, weight: .regular))
                    
                    Text(input.date)
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .semibold))
                } else {
                    Text("著者：")
                        .foregroundColor(.gray)
                        .opacity(0.9)
                        .font(.system(size: 12, weight: .regular))
                    
                    Text(input.author)
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } // VStack
            .padding(.horizontal, 15)
            .padding(.vertical, 30)
            
            Spacer(minLength: 0)
        } // HStack
        .padding(.leading, 15)
    } // body
    private func convertDataToUIImage(data: Data) -> UIImage? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return uiImage
    }
} // body

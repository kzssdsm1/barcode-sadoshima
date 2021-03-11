//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/12.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var isEditing: Bool
    @Binding var isShowAlert: Bool
    @Binding var removeItems: [String]
    @Binding var selectedItem: Item?
    
    let input: Item
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Button(action: {
                    if (isEditing) {
                        if let itemIndex = removeItems.firstIndex(where: {$0 == input.link}) {
                            removeItems.remove(at: itemIndex)
                        } else {
                            removeItems.append(input.link)
                        }
                    } else {
                        selectedItem = input
                    }
                }) {
                    HStack {
                        if let image = convertStringToUIImage(url: input.image) {
                            Image(uiImage: image)
                                // Buttonで包んだ際に色が変わらないようにするため
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.width * 0.2), height: CGFloat(geometry.size.height * 0.8))
                                .shadow(color: .gray, radius: 1, x: 0, y: 0)
                        } else {
                            // 何らかの理由により画像データを取得できなかった時は代理の画像を表示する
                            Image(systemName: "questionmark.circle")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.width * 0.2), height: CGFloat(geometry.size.height * 0.8))
                        }
                        
                        VStack(alignment: .leading) {
                            Text("タイトル：")
                                // 明示的に文字色を定義しておかないとButtonで包んだ際におかしくなる
                                .foregroundColor(.gray)
                                .opacity(0.9)
                                .font(.system(size: CGFloat(geometry.size.height * 0.1), weight: .regular))
                            
                            Text(input.title)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: CGFloat(geometry.size.height * 0.12), weight: .semibold))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                            
                            Text("追加日時：")
                                .foregroundColor(.gray)
                                .opacity(0.9)
                                .font(.system(size: CGFloat(geometry.size.height * 0.1), weight: .regular))
                            
                            Text(input.date)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .font(.system(size: CGFloat(geometry.size.height * 0.12), weight: .semibold))
                        } // VStack
                        .padding(.top, CGFloat(geometry.size.height * 0.05))
                    } // HStack
                } // Button
                .frame(height: CGFloat(geometry.size.height * 0.8))
                
                Spacer(minLength: 0)
                
                if (isEditing) {
                    if let itemIndex = removeItems.firstIndex(where: {$0 == input.link}) {
                        Button(action: {
                            removeItems.remove(at: itemIndex)
                        }) {
                            Image(systemName: "checkmark.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.width * 0.12), height: CGFloat(geometry.size.height * 0.25))
                                .foregroundColor(.blue)
                        }
                    } else {
                        Button(action: {
                            removeItems.append(input.link)
                        }) {
                            Image(systemName: "circle")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: CGFloat(geometry.size.width * 0.12), height: CGFloat(geometry.size.height * 0.25))
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                } else {
                    Button(action: {
                        removeItems.append(input.link)
                        isShowAlert = true
                    }) {
                        Image(systemName: "trash.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: CGFloat(geometry.size.width * 0.12), height: CGFloat(geometry.size.height * 0.25))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            } // HStack
        } // GeometryReader
    } // body
    
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

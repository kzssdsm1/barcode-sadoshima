//
//  CardView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/12.
//

import SwiftUI

struct CardView: View {
    @Binding var isEditing: Bool
    @Binding var showAlert: Bool
    @Binding var removeItems: [String]
    @Binding var selectedItem: Item?
    @Binding var selection: TabItem
    
    let input: Item
    
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Button(action: {
                    if isEditing {
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
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 110)
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
                        }
                        
                        VStack(alignment: .leading) {
                            Text("タイトル：")
                                .foregroundColor(.gray)
                                .opacity(0.9)
                                .font(.system(size: CGFloat(proxy.size.width * 0.04), weight: .regular))
                            
                            Text(input.title)
                                .foregroundColor(.gray)
                                .font(.system(size: CGFloat(proxy.size.width * 0.05), weight: .semibold))
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer(minLength: 0)
                            
                            if selection == .お気に入り {
                                Text("追加日時：")
                                    .foregroundColor(.gray)
                                    .opacity(0.9)
                                    .font(.system(size: CGFloat(proxy.size.width * 0.04), weight: .regular))
                                
                                Text(input.date)
                                    .foregroundColor(.gray)
                                    .font(.system(size: CGFloat(proxy.size.width * 0.05), weight: .semibold))
                            } else {
                                Text("著者：")
                                    .foregroundColor(.gray)
                                    .opacity(0.9)
                                    .font(.system(size: CGFloat(proxy.size.width * 0.04), weight: .regular))
                                
                                Text(input.author)
                                    .foregroundColor(.gray)
                                    .font(.system(size: CGFloat(proxy.size.width * 0.05), weight: .semibold))
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        } // VStack
                        .padding(.leading, 10)
                        .padding(.vertical, 30)
                        
                        Spacer(minLength: 0)
                        
                    } // HStack
                } // Button
                
                if selection == .お気に入り {
                    if !isEditing {
                        Button(action: {
                            removeItems.append(input.link)
                            showAlert = true
                        }) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .overlay(
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.gray)
                                )
                        }
                        .buttonStyle(CustomButtonStyle())
                        .frame(width: 50, height: 50)
                    } else {
                        if let itemIndex = removeItems.firstIndex(where: {$0 == input.link}) {
                            Button(action: {
                                removeItems.remove(at: itemIndex)
                            }) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .overlay(
                                        Image(systemName: "checkmark.circle.fill")
                                            .renderingMode(.template)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.accentColor)
                                    )
                            }
                            .buttonStyle(CustomButtonStyle())
                            .frame(width: 50, height: 50)
                        } else {
                            Button(action: {
                                removeItems.append(input.link)
                            }) {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .overlay(
                                        Image(systemName: "circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.gray)
                                    )
                            }
                            .buttonStyle(CustomButtonStyle())
                            .frame(width: 50, height: 50)
                        }
                    }
                }
            }
        } // HStack
        .padding(.horizontal, 15)
    } // GeometryReader
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
} // body

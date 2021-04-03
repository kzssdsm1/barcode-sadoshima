//
//  TrashButton.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/04/04.
//

import SwiftUI

struct TrashButtonView: View {
    @Binding var isEditing: Bool
    @Binding var isShowingAlert: Bool
    @Binding var removeItems: [String]
    
    let removeItem: String
    
    private var imageColor: Color {
        if isEditing {
            if removeItems.firstIndex(where: {$0 == removeItem}) != nil {
                return .accentColor
            } else {
                return .gray
            }
        } else {
            return .gray
        }
    }
    private var imageName: String {
        if isEditing {
            if removeItems.firstIndex(where: {$0 == removeItem}) != nil {
                return "checkmark.circle.fill"
            } else {
                return "circle"
            }
        } else {
            return "trash.fill"
        }
    }
    
    var body: some View {
        Button(action: {
            if isEditing {
                if let itemIndex = removeItems.firstIndex(where: {$0 == removeItem}) {
                    removeItems.remove(at: itemIndex)
                } else {
                    removeItems.append(removeItem)
                }
            } else {
                removeItems.append(removeItem)
                isShowingAlert = true
            }
        }, label: {
            Rectangle()
                .foregroundColor(.clear)
                .overlay(
                    Image(systemName: imageName)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(imageColor)
                )
        }) // Button
        .buttonStyle(CustomButtonStyle())
        .frame(width: 50, height: 50)
        .padding(.trailing, 15)
    } // body
} // TrashButtonView

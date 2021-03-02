//
//  TrashButton.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI

struct TrashButton: View {
    @Binding var removeItemString: [String]
    @Binding var isEditMode: Bool
    @Binding var isShowRemove: Bool
    
    let index: String
    
    var body: some View {
        if (isEditMode) {
            if let itemIndex = removeItemString.firstIndex(where: {$0 == self.index}) {
                Button(action: {
                    removeItemString.remove(at: itemIndex)
                }) {
                    Image(systemName: "checkmark.circle.fill")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(35), height: CGFloat(35))
                        .foregroundColor(.blue)
                }
            } else {
                Button(action: {
                    removeItemString.append(index)
                }) {
                    Image(systemName: "circle")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(35), height: CGFloat(35))
                }
            }
        } else {
            Button(action: {
                removeItemString.append(index)
                isShowRemove = true
            }) {
                Image(systemName: "trash.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
            }
        }
    }
}

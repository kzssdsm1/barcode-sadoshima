//
//  TrashButton.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/02.
//

import SwiftUI

struct TrashButton: View {
    @Binding var removeItemNum: [Int]
    @Binding var isEditMode: Bool
    @Binding var isShowRemove: Bool
    
    let index: Int
    
    var body: some View {
        if (isEditMode) {
            if let itemIndex = removeItemNum.firstIndex(where: {$0 == self.index}) {
                Button(action: {
                    removeItemNum.remove(at: itemIndex)
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
                    removeItemNum.append(index)
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
                removeItemNum.append(index)
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

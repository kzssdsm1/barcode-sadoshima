//
//  SortButtonBar.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/30.
//

import SwiftUI

struct SortButtonBar: View {
    @Binding var isAscending: Bool
    @Binding var sortKeyPath: ReferenceWritableKeyPath<FavoriteItem, String>
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            
            Text("並び順")
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .heavy))
                .padding(.trailing, 30)
            
            Button(action: {
                isAscending = true
                sortKeyPath = \FavoriteItem.title
            }) {
                Text("題名↑")
                    .foregroundColor(sortKeyPath == \FavoriteItem.title && isAscending == true ? .accentColor : .gray)
                    .font(.system(size: 14, weight: .heavy))
                    .background(
                        Group {
                            if sortKeyPath == \FavoriteItem.title && isAscending == true {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 4)
                                            .blur(radius: 4)
                                            .offset(x: 2, y: 2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.black, Color.clear)))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 8)
                                            .blur(radius: 4)
                                            .offset(x: -2, y: -2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.clear, Color.black)))
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            }
                        }
                    )
            }
            .padding(.trailing, 30)
            
            Button(action: {
                isAscending = false
                sortKeyPath = \FavoriteItem.title
            }) {
                Text("題名↓")
                    .foregroundColor(sortKeyPath == \FavoriteItem.title && isAscending == false ? .accentColor : .gray)
                    .font(.system(size: 14, weight: .heavy))
                    .background(
                        Group {
                            if sortKeyPath == \FavoriteItem.title && isAscending == false {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 4)
                                            .blur(radius: 4)
                                            .offset(x: 2, y: 2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.black, Color.clear)))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 8)
                                            .blur(radius: 4)
                                            .offset(x: -2, y: -2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.clear, Color.black)))
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            }
                        }
                    )
            }
            .padding(.trailing, 30)
            
            Button(action: {
                isAscending = true
                sortKeyPath = \FavoriteItem.date
            }) {
                Text("日時↑")
                    .foregroundColor(sortKeyPath == \FavoriteItem.date && isAscending == true ? .accentColor : .gray)
                    .font(.system(size: 14, weight: .heavy))
                    .background(
                        Group {
                            if sortKeyPath == \FavoriteItem.date && isAscending == true {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 4)
                                            .blur(radius: 4)
                                            .offset(x: 2, y: 2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.black, Color.clear)))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 8)
                                            .blur(radius: 4)
                                            .offset(x: -2, y: -2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.clear, Color.black)))
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            }
                        }
                    )
            }
            .padding(.trailing, 30)
            
            Button(action: {
                isAscending = false
                sortKeyPath = \FavoriteItem.date
            }) {
                Text("日時↓")
                    .foregroundColor(sortKeyPath == \FavoriteItem.date && isAscending == false ? .accentColor : .gray)
                    .font(.system(size: 14, weight: .heavy))
                    .background(
                        Group {
                            if sortKeyPath == \FavoriteItem.date && isAscending == false {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray, lineWidth: 4)
                                            .blur(radius: 4)
                                            .offset(x: 2, y: 2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.black, Color.clear)))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.white, lineWidth: 8)
                                            .blur(radius: 4)
                                            .offset(x: -2, y: -2)
                                            .mask(RoundedRectangle(cornerRadius: 15).fill(LinearGradient(Color.clear, Color.black)))
                                    )
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.offWhite)
                                    .frame(width: 60, height: 35)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            }
                        }
                    )
            }
            
            Spacer(minLength: 0)
        } // HStack
        .padding(10)
        .frame(height: 60)
    } // body
}


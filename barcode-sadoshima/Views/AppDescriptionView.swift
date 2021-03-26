//
//  AppDescriptionView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/26.
//

import SwiftUI

struct AppDescriptionView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    Text("アプリの使い方")
                        .font(.system(size: CGFloat(geometry.size.height * 0.03), weight: .heavy))
                    
                    Spacer(minLength: 0)
                } // HStack
                .padding((geometry.size.width * 0.02))
                .frame(height: CGFloat(60))
                
                VStack {
                    HStack {
                        Image(systemName: "camera.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (geometry.size.width * 0.18))
                            .foregroundColor(.blue)
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: (geometry.size.width * 0.01),
                                    bottom: 0,
                                    trailing: (geometry.size.width * 0.05)
                                )
                            )
                        
                        Text("バーコードスキャナーで書籍のバーコードを読み取ります")
                            .font(.system(size: (geometry.size.height * 0.025), weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, (geometry.size.height * 0.1))
                    
                    HStack {
                        Text("バーコードの読み取りに成功すると自動で楽天ブックスで書籍データが検索されます")
                            .font(.system(size: (geometry.size.height * 0.025), weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: (geometry.size.width * 0.01),
                                    bottom: 0,
                                    trailing: (geometry.size.width * 0.05)
                                )
                            )
                        
                        Image(systemName: "network")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (geometry.size.width * 0.18))
                            .foregroundColor(.blue)
                        
                    } // HStack
                    .padding(.bottom, (geometry.size.height * 0.1))
                    
                    HStack {
                        Image(systemName: "book.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (geometry.size.width * 0.18))
                            .foregroundColor(.blue)
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: (geometry.size.width * 0.01),
                                    bottom: 0,
                                    trailing: (geometry.size.width * 0.05)
                                )
                            )
                        
                        VStack {
                            Text("検索に成功すると書籍の詳細画面が開きます")
                                .font(.system(size: (geometry.size.height * 0.025), weight: .medium))
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("書籍の詳細画面では書籍をお気に入り登録することが出来ます")
                                .font(.system(size: (geometry.size.height * 0.025), weight: .medium))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    .padding(.bottom, (geometry.size.height * 0.1))
                    
                    HStack {
                        Text("お気に入り登録した書籍はお気に入りリストからいつでも見返すことが出来ます")
                            .font(.system(size: (geometry.size.height * 0.025), weight: .medium))
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.trailing, (geometry.size.width * 0.05))
                            .padding(
                                EdgeInsets(
                                    top: 0,
                                    leading: (geometry.size.width * 0.01),
                                    bottom: 0,
                                    trailing: (geometry.size.width * 0.05)
                                )
                            )
                        
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: (geometry.size.width * 0.18))
                            .foregroundColor(.blue)
                    } // HStack
                    .padding(.bottom, (geometry.size.height * 0.2))
                } // VStack
                .padding(.horizontal, (geometry.size.height * 0.03))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } // GeometryReader
        } // body
    }
}

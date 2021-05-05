//
//  AppDescriptionView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/03/26.
//

import SwiftUI

struct AppDescriptionView: View {
    private let screenWidth = CGFloat(UIScreen.main.bounds.width)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("アプリの使い方")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.gray)
                    .padding(.leading, 10)
                
                Spacer(minLength: 0)
            } // HStack
            .frame(height: 60)
            .padding(.bottom, 30)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(maxWidth: screenWidth - 50)
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .overlay(
                            HStack {
                                Image(systemName: "camera.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(.calmBlue)
                                    .opacity(0.8)
                                    .padding(.trailing, 20)
                                
                                Text("バーコードスキャナーで書籍のバーコードを読み取ります")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(15)
                        )
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(maxWidth: screenWidth - 50)
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .overlay(
                            HStack {
                                Text("バーコードの読み取りに成功すると自動で楽天ブックスAPIを使用して書籍データが検索されます")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.trailing, 20)
                                
                                Image(systemName: "network")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                                    .foregroundColor(.vividGreen)
                                    .opacity(0.8)
                            }
                            .padding(15)
                        )
                        .padding(.bottom, 40)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(maxWidth: screenWidth - 50)
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .overlay(
                            HStack {
                                Image(systemName: "book.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(.deepPurple)
                                    .opacity(0.8)
                                    .padding(.trailing, 20)
                                
                                VStack(alignment: .leading) {
                                    Text("検索に成功すると書籍の詳細画面が開きます")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("書籍の詳細画面では書籍をお気に入り登録することが出来ます")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                } // VStack
                            }
                            .padding(15)
                        )
                        .padding(.bottom, 40)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(maxWidth: screenWidth - 50)
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("検索タブからキーワードで書籍を探すことも出来ます")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text("関連性の高いもの30件が表示されます")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)
                                } // VStack
                                .padding(.trailing, 20)
                                
                                Image(systemName: "magnifyingglass")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(.mikan)
                                    .opacity(0.8)
                            } // HStack
                            .padding(15)
                        )
                        .padding(.bottom, 40)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.offWhite)
                        .frame(maxWidth: screenWidth - 50)
                        .frame(height: 200)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .overlay(
                            HStack {
                                Image(systemName: "star.fill")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                                    .foregroundColor(.gold)
                                    .opacity(0.8)
                                    .padding(.trailing, 20)
                                
                                Text("お気に入り登録した書籍はお気に入りリストからいつでも見返すことが出来ます")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            } // HStack
                            .padding(15)
                        )
                        .padding(.bottom, 90)
                } // VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } // ScrollView
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
    } // body
}

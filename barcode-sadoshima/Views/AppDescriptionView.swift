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
                VStack {
                    HStack {
                        Image(systemName: "camera.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.calmBlue)
                            .padding(.trailing, 20)
                        
                        Text("バーコードスキャナーで書籍のバーコードを読み取ります")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical ,20)
                    .padding(.horizontal, 40)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: screenWidth - 50, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
                    .padding(.bottom, 20)
                    
                    HStack {
                        Text("バーコードの読み取りに成功すると自動で楽天ブックスで書籍データが検索されます")
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
                    }
                    .padding(.vertical ,20)
                    .padding(.horizontal, 40)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: screenWidth - 50, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "book.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.deepPurple)
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
                        }
                    }
                    .padding(.vertical ,20)
                    .padding(.horizontal, 40)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: screenWidth - 50, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
                    .padding(.bottom, 20)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("検索タブからタイトルで書籍を探すことも出来ます")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("関連性の高いもの30件が表示されます")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.trailing, 20)
                        
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical ,20)
                    .padding(.horizontal, 40)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: screenWidth - 50, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
                    .padding(.bottom, 20)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60)
                            .foregroundColor(.yellow)
                            .padding(.trailing, 20)
                        
                        Text("お気に入り登録した書籍はお気に入りリストからいつでも見返すことが出来ます")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical ,20)
                    .padding(.horizontal, 40)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.offWhite)
                            .frame(width: screenWidth - 50, height: 200)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    )
                    .padding(.bottom, 90)
                }
            }
        } // VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.offWhite.edgesIgnoringSafeArea(.all))
    } // body
}

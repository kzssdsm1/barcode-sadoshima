//
//  HomeViewModel.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/05.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
    @Published var scannedCode = ""
    @Published var alertItem: AlertItem?
    
    var statusText: String { scannedCode.isEmpty ? "コードをスキャンしてください" : scannedCode }
    var statusTextColor: Color { scannedCode.isEmpty ? .green : .red }
    var scannedCodeIsValid: Bool { scannedCode.isEmpty ? true : false }
    
    let navigationTitle = "バーコードスキャナー"
}

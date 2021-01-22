//
//  ContentView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/21.
//

import SwiftUI

struct ContentView: View, BarcodeScannerViewDelegate {
    
    @State var scannedCode: String
    @State var alertItem: AlertItem?
    
    var body: some View {
        NavigationView {
            BarcodeScannerView(scannerViewDelegate: self)
        }
        .alert(item: $alertItem) { alertItem in
            Alert.init(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: alertItem.dismissButton)
        }
    }
    
    func didFind(barcode: String) {
        self.scannedCode = barcode
        print("ISBN-\(scannedCode)")
    }
    
    func didSurface(error: ScanError) {
        switch error {
        case .invalidDeviceInput:
            alertItem = AlertContext.invalidDeviceInput
        case .invalidScannedValue:
            alertItem = AlertContext.invalidScannedType
        }
    }
}

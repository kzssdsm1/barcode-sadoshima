//
//  BarcodeScannerView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/05.
//

import SwiftUI

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    @Binding var alertItem: AlertItem?
    
    func makeUIViewController(context: Context) -> BarcodeScannerViewController {
        BarcodeScannerViewController(scannerDelegate: context.coordinator)
    }
    
    func updateUIViewController(_ uiViewController: BarcodeScannerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(scannerView: self)
    }
    
    final class Coordinator: NSObject, BarcodeScannerViewControllerDelegate {
        
        private let scannerView: BarcodeScannerView
        
        init(scannerView: BarcodeScannerView) {
            self.scannerView = scannerView
        }
        
        func didFind(barcode: String) {
            scannerView.scannedCode = barcode
        }
        
        func didSurface(error: ScanError) {
            switch error {
            case .invalidDeviceAction:
                scannerView.alertItem = AlertContext.invalidDeviceAction
            case .invalidScannedValue:
                scannerView.alertItem = AlertContext.invalidScannedValue
            }
        }
    }
}


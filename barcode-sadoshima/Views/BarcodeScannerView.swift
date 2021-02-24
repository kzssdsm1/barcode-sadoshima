//
//  BarcodeScannerView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/19.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var isSessionStart: Bool
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    @Binding var alertItem: AlertItem?
    
    private enum ScanError {
        case invalidDeviceInput, invalidSacnnedValue
    }
    
    private let captureSession = AVCaptureSession()
    private let viewController = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScannerView>) -> UIViewController {
        if self.isSessionStart != true {
            self.isSessionStart = true
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        if let captureDevice = discoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) {
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                } else {
                    didSurface(error: .invalidDeviceInput)
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if captureSession.canAddOutput(metadataOutput) {
                    captureSession.addOutput(metadataOutput)
                    metadataOutput.rectOfInterest = CGRect(x: 0.3, y: 0.1, width: 0.2, height: 0.8)
                    metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
                    metadataOutput.metadataObjectTypes = [.ean8, .ean13]
                } else {
                    didSurface(error: .invalidDeviceInput)
                }
            }
            
            DispatchQueue.global().async {
                startSession()
                
                DispatchQueue.main.async {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = viewController.view.bounds
                    previewLayer.videoGravity = .resizeAspectFill
                    
                    viewController.view.layer.addSublayer(previewLayer)
                    viewController.view.addSubview(makeBorderline())
                }
                
            }
            
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<BarcodeScannerView>) {
    }
    
    private func startSession() {
        guard !captureSession.isRunning else { return }
        captureSession.startRunning()
    }
    
    private func endSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    private func didFind(barcode: String) {
        endSession()
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        onCommitSubject.send(barcode)
    }
    
    private func didSurface(error: ScanError) {
        switch error {
        case .invalidDeviceInput:
            alertItem = AlertContext.invalidDeviceAction
        case .invalidSacnnedValue:
            alertItem = AlertContext.invalidScannedValue
        }
    }
    
    private func makeBorderline() -> UIView {
        let screenWidth = CGFloat(UIScreen.main.bounds.width)
        let screenHeight = CGFloat(UIScreen.main.bounds.height)
        let borderline = UIView()
        borderline.frame = CGRect(x: screenWidth * 0.1, y: screenHeight * 0.3,
                                  width: screenWidth * 0.8, height: screenHeight * 0.2)
        
        borderline.layer.borderColor = Color(.red).cgColor
        borderline.layer.borderWidth = 3
        
        return borderline
    }
    
    private func convertISBN(value: String) -> String? {
        let v = NSString(string: value).longLongValue
        let prefix: Int64 = Int64(v / 10000000000)
        guard prefix == 978 || prefix == 979 else { return nil }
        let isbn9: Int64 = (v % 10000000000) / 10
        var sum: Int64 = 0
        var tmpISBN = isbn9
        
        var i = 10
        while i > 0 && tmpISBN > 0 {
            let divisor: Int64 = Int64(pow(10, Double(i - 2)))
            sum += (tmpISBN / divisor) * Int64(i)
            tmpISBN %= divisor
            i -= 1
        }
        
        let checkdigit = 11 - (sum % 11)
        return String(format: "%lld%@", isbn9, (checkdigit == 10) ? "X" : String(format: "%lld", checkdigit % 11))
    }
}

extension BarcodeScannerView {
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            
            guard let metadataObject = metadataObjects.first else {
                parent.didSurface(error: .invalidSacnnedValue)
                return
            }
            
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                parent.didSurface(error: .invalidSacnnedValue)
                return
            }
            guard let stringValue = readableObject.stringValue else {
                parent.didSurface(error: .invalidSacnnedValue)
                return
            }
            guard let isbn = parent.convertISBN(value: stringValue) else {
                parent.didSurface(error: .invalidSacnnedValue)
                return
            }
            
            parent.didFind(barcode: isbn)
        }
    }
}

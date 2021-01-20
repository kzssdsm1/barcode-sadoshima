//
//  BarcodeScannerView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/21.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    
    private let captureSession = AVCaptureSession()
    
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            parent.captureSession.stopRunning()
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }
                guard let isbn = parent.convertISBN(value: stringValue) else { return }
                
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScannerView>) -> UIViewController {
        let viewController = UIViewController()
        
        viewController.view.frame = UIScreen.main.bounds
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        if let selectedDevice = discoverySession.devices.first {
            if let videoInput = try? AVCaptureDeviceInput(device: selectedDevice) {
                
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                } else {
                    
                }
                
                let metadataOutput = AVCaptureMetadataOutput()
                
                if captureSession.canAddOutput(metadataOutput) {
                    captureSession.addOutput(metadataOutput)
                    metadataOutput.rectOfInterest = CGRect(x: 0.3, y: 0.1, width: 0.2, height: 0.8)
                    metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: .main)
                    metadataOutput.metadataObjectTypes = [.ean8, .ean13]
                } else {
                    
                }
                
                DispatchQueue.global().async {
                    captureSession.startRunning()
                    
                    DispatchQueue.main.async {
                        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        previewLayer.frame = viewController.view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        
                        viewController.view.layer.addSublayer(previewLayer)
                        viewController.view.addSubview(makeBorderline())
                    }
                }
            }
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<BarcodeScannerView>) {
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

//
//  BarcodeScannerView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/01/22.
//

import SwiftUI
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    @ObservedObject (initialValue: RakutenAPIDataModel()) private var rakutenAPIDataModel
    
    private enum ScanError {
        case invalidDeviceInput, invalidSacnnedValue
    }
    
    private struct AlertItem: Identifiable {
        let id = UUID()
        let title: String
        let message: String
        let dismissTitle: String
    }
    
    private struct AlertContext {
        static let validScannedValue = AlertItem(
            title: "バーコードの読み取りに成功",
            message: "楽天ブックスで書籍の検索を行います",
            dismissTitle: "Cancel"
        )
        
        static let invalidDeviceInput = AlertItem(
            title: "無効なデバイス入力",
            message: "不明なエラーによりバーコードが読み取れませんでした",
            dismissTitle: "OK"
        )
        
        static let invalidScannedValue = AlertItem(
            title: "無効なバーコード形式",
            message: "このアプリはEAN-8、EAN-13以外のバーコード形式には対応しておりません",
            dismissTitle: "OK"
        )
    }
    
    private let captureSession = AVCaptureSession()
    private let viewController = UIViewController()
    
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            parent.captureSession.stopRunning()
            if let metadataObject = metadataObjects.first {
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScannerView>) -> UIViewController {
        
        viewController.view.frame = UIScreen.main.bounds
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        if let selectedDevice = discoverySession.devices.first {
            if let videoInput = try? AVCaptureDeviceInput(device: selectedDevice) {
                
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
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
    
    private func didFind(barcode: String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        rakutenAPIDataModel.scannedCode = barcode
        showAlert(alertItem: AlertContext.validScannedValue)
    }
    
    private func didSurface(error: ScanError) {
        switch error {
        case .invalidDeviceInput:
            showAlert(alertItem: AlertContext.invalidDeviceInput)
        case .invalidSacnnedValue:
            showAlert(alertItem: AlertContext.invalidScannedValue)
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
    
    private func showAlert(alertItem: AlertItem) {
        let alert = UIAlertController(title: alertItem.title, message: alertItem.message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: alertItem.dismissTitle, style: .cancel, handler: {_ in
            captureSession.startRunning()
        })
        let search = UIAlertAction(title: "OK", style: .default, handler: {_ in
            rakutenAPIDataModel.fetchItem()
        })
        
        if alertItem.dismissTitle == "Cancel" {
            alert.addAction(cancel)
            alert.addAction(search)
        } else {
            alert.addAction(cancel)
        }
        
        viewController.present(alert, animated: true, completion: nil)
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

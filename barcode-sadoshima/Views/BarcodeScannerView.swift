//
//  BarcodeScannerView.swift
//  barcode-sadoshima
//
//  Created by 佐渡島和志 on 2021/02/28.
//

import SwiftUI
import UIKit
import Combine
import AVFoundation

struct BarcodeScannerView: UIViewControllerRepresentable {
    @Binding var alertItem: AlertItem?
    @Binding var captureSession: AVCaptureSession
    @Binding var isLoading: Bool
    @Binding var onCommitSubject: PassthroughSubject<String, Never>
    
    private let viewController = UIViewController()
    
    private enum ScanError {
        case invalidDeviceInput, invalidSacnnedValue
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<BarcodeScannerView>) -> UIViewController {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        if let captureDevice = discoverySession.devices.first {
            if let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) {
                for ii in captureSession.inputs {
                    captureSession.removeInput(ii as AVCaptureInput)
                }
                
                if captureSession.canAddInput(deviceInput) {
                    captureSession.addInput(deviceInput)
                } else {
                    didSurface(error: .invalidDeviceInput)
                }
                
                for ii in captureSession.outputs {
                    captureSession.removeOutput(ii as AVCaptureOutput)
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
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = viewController.view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            
            viewController.view.layer.addSublayer(previewLayer)
            viewController.view.addSubview(makeBorderline())
        }
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<BarcodeScannerView>) {}
    
    private func endSession() {
        guard captureSession.isRunning else { return }
        captureSession.stopRunning()
    }
    
    /// ISBNの読み取りに成功するとバイブレーションを鳴らしてHomeViewModelにストリームを流すメソッド
    /// - Parameter barcode: ISBNコード
    private func didFind(barcode: String) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        isLoading = true
        onCommitSubject.send(barcode)
    }
    
    /// エラーが発生した際にalertItemに値を格納するメソッド（値が格納されると自動でアラートが呼び出される）
    /// - Parameter error: エラーの型
    private func didSurface(error: ScanError) {
        switch error {
        case .invalidDeviceInput:
            alertItem = AlertContext.invalidDeviceAction
        case .invalidSacnnedValue:
            alertItem = AlertContext.invalidScannedValue
        }
    }
    
    /// カメラの検知を範囲を示す枠線を追加する関数
    /// - Returns: 枠線
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
}

extension BarcodeScannerView {
    final class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: BarcodeScannerView
        
        init(parent: BarcodeScannerView) {
            self.parent = parent
        }
        
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            parent.endSession()
            
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
            
            parent.didFind(barcode: stringValue)
        }
    }
}

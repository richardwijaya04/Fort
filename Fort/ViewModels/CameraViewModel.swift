//
//  CameraViewModel.swift
//  Fort
//
//  Created by William on 20/07/25.
//


import Foundation
import AVFoundation
import Vision
import CoreImage
import SwiftUI

final class OCRCameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isShowConfirmationAlert: Bool = false
    @Published var isShowErrorAlert: Bool = false
    @Published var isProcessing: Bool = false
    @Published var isOCRConfirmed: Bool = false
    @Published var resultOCR : OCRResult? {
        didSet {
            updateConfirmationData(from: resultOCR)
        }
    }
    
    
    @Published var confirmationName: String = ""
    @Published var confirmationNIK: String = ""
    @Published var confirmationBirthDate: String = "" 

    

    let session = AVCaptureSession()
    let output = AVCapturePhotoOutput()
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") // 🔐 Serial queue
    var visionController: VisionManager
    
    init(visionController: VisionManager) {
        self.visionController = visionController
    }

    
    func startCamera() {
        sessionQueue.async {
            if !self.session.isRunning {
                self.session.startRunning()
            }
        }
    }
    
    func stopCamera() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func toggleCamera() {
        sessionQueue.async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
            else {
                self.session.startRunning()
            }
        }
    }
    
    func toggleConfirmationAlert() {
        DispatchQueue.main.async {
            withAnimation {
                self.isShowConfirmationAlert.toggle()
            }
        }
        toggleCamera()
    }
    
    
    
    func processOnCapturePhotoButtonClicked() {
        isProcessing = true

        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data),
              let cgImage = image.cgImage else {
            print("Failed to get image")
            return
        }

        visionController.processCapturedImage(cgImage) { result in
            guard let isValidKTP = result.0, let retValOCR = result.1 else {
                DispatchQueue.main.async {
                    self.isProcessing = false
                    self.isShowErrorAlert = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.resultOCR = retValOCR
                self.isProcessing = false
            }
            
            if (isValidKTP){
                self.toggleConfirmationAlert()
            }
        }
    }

    func updateConfirmationData (from result : OCRResult?){
        guard let result = result else {return}
        confirmationName = result.name ?? "-"
        confirmationNIK = result.nik ?? "-"
        confirmationBirthDate = IOHelper.dateToString(result.birthDate ?? Date())
    }

    func formatBirthDate(newValue : String, oldValue : String) {
        if (newValue.count > 10){
            confirmationBirthDate = oldValue
            return
        }
        
        var updated = newValue.replacingOccurrences(of: "/", with: "")
        
        if updated.count > 2 {
            updated.insert("/", at: updated.index(updated.startIndex, offsetBy: 2))
        }
        if updated.count > 5 {
            updated.insert("/", at: updated.index(updated.startIndex, offsetBy: 5))
        }
        
        // Prevent infinite loop
        if confirmationBirthDate != updated {
            confirmationBirthDate = updated
        }
    }
}

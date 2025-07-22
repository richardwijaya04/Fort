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

final class OCRCameraViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isShowConfirmationAlert: Bool = false
    @Published var isProcessing: Bool = false
    
    let session = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    let output = AVCapturePhotoOutput()
    
    private let sessionQueue = DispatchQueue(label: "camera.session.queue") // 🔐 Serial queue
    var visionController: VisionManager
    
    init(visionController: VisionManager) {
        self.visionController = visionController
    }
    
    func addOutputVideoBufferToVision() {
        session.addOutput(videoOutput)
        videoOutput.setSampleBufferDelegate(visionController, queue: DispatchQueue(label: "vision.request.queue"))
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
    
    
    
    func processOnCapturePhotoButtonClicked(state : Color) {
        if (state != Color("Primary")){
            return
        }
        
        toggleConfirmationAlert()
    }
}

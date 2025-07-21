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

final class OCRCameraViewModel: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    let session = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()

    var visionController : VisionController
    
    init(visionController: VisionController) {
        self.visionController = visionController
    }
    
    func addOutputVideoBufferToVision() {
        session.addOutput(videoOutput)
        videoOutput.setSampleBufferDelegate(visionController, queue: DispatchQueue(label: "vision.request.queue"))
    }
    
    func startCamera(){
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
}

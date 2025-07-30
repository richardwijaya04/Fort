//
//  CameraPreview.swift
//  PassiveLivenessApp
//
//  Created by Lin Dan Christiano on 21/07/25.
//


import SwiftUI
import AVFoundation
import Vision

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var viewModel: LivenessViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        let captureSession = AVCaptureSession()
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            return view
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "camera_queue"))
            
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            
            context.coordinator.previewLayer = previewLayer
            context.coordinator.captureSession = captureSession
            
            DispatchQueue.global(qos: .userInitiated).async {
                captureSession.startRunning()
            }
            
        } catch {
            print("Error setting up camera: \(error)")
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = context.coordinator.previewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        let viewModel: LivenessViewModel
        var previewLayer: AVCaptureVideoPreviewLayer?
        var captureSession: AVCaptureSession?
        
        init(viewModel: LivenessViewModel) {
            self.viewModel = viewModel
        }
        
        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            // Simple face detection using Vision framework
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
                DispatchQueue.main.async {
                    if let results = request.results as? [VNFaceObservation], !results.isEmpty {
                        self?.viewModel.isFaceDetected = true
                    } else {
                        self?.viewModel.isFaceDetected = false
                    }
                }
            }
            
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try? handler.perform([request])
        }
        
        deinit {
            captureSession?.stopRunning()
        }
    }
}

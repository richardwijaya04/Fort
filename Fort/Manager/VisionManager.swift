import AVFoundation
import Foundation
import SwiftUI
import UIKit
import CoreVideo
import CoreImage
import Vision

final class VisionManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @Published var image: UIImage?
    @Published var borderColor : Color = .red
    
    private let ciContext = CIContext()
    private var lastProcessTime = Date()
    private var ocrTask: Task<Void, Never>?
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard Date().timeIntervalSince(lastProcessTime) > 0.5 else { return }
        lastProcessTime = Date()
        
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let processedBuffer = processImageBuffer(buffer) else { return }
        
        detectAndCropKTP(from: processedBuffer) { [weak self] ktpImage in
            guard let self = self else { return }
            
            guard let img = ktpImage,
                  let cgImage = self.ciContext.createCGImage(img, from: img.extent) else {
                self.setBorderState(to: .red)
                return
            }
            
            self.setBorderState(to: .yellow)
            
            self.ocrTask?.cancel()
            self.ocrTask = Task {
                let textRequest = VNRecognizeTextRequest()
                textRequest.recognitionLevel = .accurate
                textRequest.usesLanguageCorrection = true
                
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([textRequest])
                } catch {
                    print("OCR error: \(error)")
                }
                
                let texts = textRequest.results?
                    .compactMap { $0.topCandidates(1).first?.string.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []
                
                print(texts)
                OCRResult.processOCRText(texts)
                //TODO: Add keyword matching for “NIK”, etc. and set .green
            }
        }
    }
}

private extension VisionManager {
    ///Process image buffer (buffer sent is gonna be equivalent to what the user see in the cameraView)
    func processImageBuffer(_ buffer: CVImageBuffer) -> CGImage? {
        let ciImage = CIImage(cvImageBuffer: buffer)
        
        // Step 1: Rotate 90° clockwise (portrait)
        let rotatedTransform = CGAffineTransform(translationX: ciImage.extent.height, y: 0)
            .rotated(by: -.pi / 2)
        let rotatedCI = ciImage.transformed(by: rotatedTransform)
        
        // Step 2: Crop middle 35% (cut 35% from top, 30% from bottom)
        let extent = rotatedCI.extent
        let totalHeight = extent.height
        
        let cropStartY = totalHeight * 0.30         // leave 30% from bottom
        let cropHeight = totalHeight * 0.35         // 100% - 35% top - 30% bottom
        
        let croppedRect = CGRect(
            x: extent.origin.x,
            y: extent.origin.y + cropStartY,
            width: extent.width,
            height: cropHeight
        )
        
        let croppedCI = rotatedCI.cropped(to: croppedRect)
        
        // Step 3: Render to UIImage safely
        let context = CIContext()
        guard let cgImage = context.createCGImage(croppedCI, from: croppedCI.extent) else { return nil }
        
        return cgImage
    }
    
    
    func detectAndCropKTP(from cgImage: CGImage, completion: @escaping (CIImage?) -> Void) {
        let ciImage = CIImage(cgImage: cgImage)
        let imageSize = ciImage.extent.size
        
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
        let rectangleRequest = VNDetectRectanglesRequest { request, error in
            guard
                error == nil,
                let results = request.results as? [VNRectangleObservation],
                let ktpRect = results.first
            else {
                print("No rectangle detected")
                completion(nil)
                return
            }
            
            let boundingBox = ktpRect.boundingBox
            
            // Flip Y-axis
            let flippedY = 1.0 - boundingBox.origin.y - boundingBox.height
            
            let rectInPixels = CGRect(
                x: boundingBox.origin.x * imageSize.width,
                y: flippedY * imageSize.height,
                width: boundingBox.size.width * imageSize.width,
                height: boundingBox.size.height * imageSize.height
            )
            
            let cropped = ciImage.cropped(to: rectInPixels)
            completion(cropped)
        }
        
        rectangleRequest.minimumConfidence = 0.8
        rectangleRequest.maximumObservations = 1
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([rectangleRequest])
            } catch {
                print("Rectangle detection failed: \(error)")
                completion(nil)
            }
        }
    }
    
    func setBorderState(to color: Color) {
        DispatchQueue.main.async {
            withAnimation {
                self.borderColor = color
            }
        }
    }
}

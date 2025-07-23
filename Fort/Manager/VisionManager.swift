import AVFoundation
import Foundation
import SwiftUI
import UIKit
import CoreVideo
import CoreImage
import Vision

final class VisionManager: NSObject, ObservableObject {
    
    @Published var image: UIImage?
    
    private let ciContext = CIContext()
    private var lastProcessTime = Date()
    private var ocrTask: Task<Void, Never>?
    
    enum detectKTPResult {
        case notDetected
        case detectionFailed(Error)
        case cropped(CIImage)
    }
    
    func processCapturedImage(_ cgImage: CGImage, completion : @escaping ((Bool?, OCRResult?)) -> Void) {

        detectAndCropKTP(from: cgImage) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .notDetected:
                completion((false, nil))
                return
            case .detectionFailed(let error):
                print("\(error)")
                return
            case .cropped(let ktpImage):
                guard let croppedCG = self.ciContext.createCGImage(ktpImage, from: ktpImage.extent) else {
                    completion((false, OCRResult()))
                    return
                }


                self.ocrTask?.cancel()
                self.ocrTask = Task {
                    let request = VNRecognizeTextRequest()
                    request.recognitionLevel = .accurate
                    request.usesLanguageCorrection = true

                    let handler = VNImageRequestHandler(cgImage: croppedCG, options: [:])
                    try? handler.perform([request])

                    let texts = request.results?
                        .compactMap { $0.topCandidates(1).first?.string.trimmingCharacters(in: .whitespacesAndNewlines) } ?? []

    //                print("OCR result: \(texts)")
                    let res = OCRResult.processOCRText(texts).1
                    print(res.printSummary())
                    
                    
                    completion((true, res))
                }
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
    
    
    func detectAndCropKTP(from cgImage: CGImage, completion: @escaping (detectKTPResult) -> Void) {
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
                completion(.notDetected)
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
            completion(.cropped(cropped))
        }
        
        rectangleRequest.minimumConfidence = 0.8
        rectangleRequest.maximumObservations = 1
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([rectangleRequest])
            } catch {
                print("Rectangle detection failed: \(error)")
                completion(.detectionFailed(error))
            }
        }
    }
}

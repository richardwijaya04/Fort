//
//  LivenessViewModel.swift
//  PassiveLivenessApp
//
//  Created by Lin Dan Christiano on 16/07/25.
//

import ARKit
import SwiftUI
import Combine

class LivenessViewModel: ObservableObject {
    @Published var statusMessage: String = "Posisikan wajah Anda di dalam bingkai"
    @Published var isFaceInFrame: Bool = false
    @Published var isSuccess: Bool = false
    @Published var isFailure: Bool = false
    @Published var currentChallengeNumber: Int = 0
    @Published var totalChallenges: Int = 3
    @Published var isFaceDetected: Bool = false
    @Published var isMaskDetected: Bool = false
    
    private var frameRect: CGRect = .zero
    private let livenessValidator = LivenessValidator()
    
    private let frameTolerance: CGFloat = 50.0
    
    func setFrame(rect: CGRect) {
        self.frameRect = rect
    }
    
    func process(anchor: ARFaceAnchor?, faceScreenPoint: CGPoint?) {
        guard let anchor = anchor else {
            statusMessage = "Wajah tidak terdeteksi. Posisikan wajah Anda di dalam bingkai"
            isFaceInFrame = false
            isFaceDetected = false
            return
        }
        
        isFaceDetected = true
        
        if let facePoint = faceScreenPoint {
            let isInFrame = checkIfFaceInFrame(facePoint: facePoint)
            isFaceInFrame = isInFrame
            
            if !isInFrame {
                statusMessage = "Posisikan wajah Anda di dalam bingkai"
                return
            }
        }
        
        let status = livenessValidator.validate(anchor: anchor)
        
        switch status {
        case .validating(let challenge):
            statusMessage = "\(challenge.description)"
            
        case .success:
            statusMessage = "Validasi berhasil!"
            isSuccess = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.resetValidation()
            }
            
        case .failure(let reason):
            statusMessage = reason
            isFaceInFrame = false
            self.isFailure = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.resetValidation()
            }
            
        case .challengeCompleted:
            currentChallengeNumber += 1
            if currentChallengeNumber < totalChallenges {
                statusMessage = ""
            }
        }
    }
    
    private func checkIfFaceInFrame(facePoint: CGPoint) -> Bool {
        let centerX = frameRect.midX
        let centerY = frameRect.midY
        let radiusX = frameRect.width / 2
        let radiusY = frameRect.height / 2
        
        let normalizedX = (facePoint.x - centerX) / radiusX
        let normalizedY = (facePoint.y - centerY) / radiusY
        let distance = sqrt(normalizedX * normalizedX + normalizedY * normalizedY)
        
        return distance <= 1.2
    }
    
    func startFaceDetection() {
        isFaceDetected = false
        isMaskDetected = false
        statusMessage = "Taruh wajah di kamera"
    }
    
    func startLivenessDetection() {
        statusMessage = "Memulai verifikasi..."
    }
    
    func stopSession() {
        resetValidation()
    }
    
    private func resetValidation() {
        livenessValidator.reset()
        statusMessage = "Posisikan wajah Anda di dalam bingkai"
        isFaceInFrame = false
        isSuccess = false
        currentChallengeNumber = 0
        isFaceDetected = false
        isMaskDetected = false
        isFailure = false
    }
    
    func restartValidation() {
        resetValidation()
    }
}

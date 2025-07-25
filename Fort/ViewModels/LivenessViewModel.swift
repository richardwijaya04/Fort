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
    
    // Tolerance untuk menentukan apakah wajah berada di dalam frame
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
        
        // Periksa apakah wajah berada di dalam frame
        if let facePoint = faceScreenPoint {
            let isInFrame = checkIfFaceInFrame(facePoint: facePoint)
            isFaceInFrame = isInFrame
            
            if !isInFrame {
                statusMessage = "Posisikan wajah Anda di dalam bingkai"
                return
            }
        }
        
        // Jika wajah sudah di dalam frame, lakukan validasi liveness
        let status = livenessValidator.validate(anchor: anchor)
        
        switch status {
        case .validating(let challenge):
            statusMessage = "\(challenge.description)"
            
        case .success:
            statusMessage = "Validasi berhasil!"
            isSuccess = true
            
            // Reset setelah 2 detik
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.resetValidation()
            }
            
        case .failure(let reason):
            statusMessage = reason
            isFaceInFrame = false
            self.isFailure = true
            
            // Reset setelah 2 detik
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
        
        // Hitung jarak dari pusat oval (normalisasi untuk bentuk elips)
        let normalizedX = (facePoint.x - centerX) / radiusX
        let normalizedY = (facePoint.y - centerY) / radiusY
        let distance = sqrt(normalizedX * normalizedX + normalizedY * normalizedY)
        
        // Tambahkan toleransi untuk membuat deteksi lebih mudah
        return distance <= 1.2 // 1.2 memberikan sedikit ruang di luar bingkai
    }
    
    func startFaceDetection() {
        // Reset states for face detection phase
        isFaceDetected = false
        isMaskDetected = false
        statusMessage = "Taruh wajah di kamera"
    }
    
    func startLivenessDetection() {
        // Start the actual liveness detection process
        statusMessage = "Memulai verifikasi..."
        // The AR process will begin and take over
    }
    
    func stopSession() {
        // Stop any running sessions
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

//
//  LivenessValidator.swift
//  PassiveLivenessApp
//
//  Created by Lin Dan Christiano on 16/07/25.
//

import ARKit
import simd

enum LivenessChallenge: CaseIterable {
    case turnHeadLeft, turnHeadRight, smile, blink
     
    var description: String {
        switch self {
        case .turnHeadLeft: return "Putar kepala ke kiri"
        case .turnHeadRight: return "Putar kepala ke kanan"
        case .smile: return "Mohon tersenyum"
        case .blink: return "Silakan berkedip"
        }
    }
}

enum LivenessStatus {
    case validating(challenge: LivenessChallenge)
    case challengeCompleted
    case success
    case failure(String)
}

class LivenessValidator {
    private var validationStartTime: Date?
    private let validationTimeout: TimeInterval = 15.0
    private var challenges: [LivenessChallenge] = []
    private var currentChallengeIndex: Int = 0
    private var challengeStartTime: Date?
    private let challengeTimeout: TimeInterval = 5.0
    private var isWaitingForNextChallenge: Bool = false
    private let totalChallenges: Int = 3

    init() {
        reset()
    }

    func reset() {
        validationStartTime = nil
        challengeStartTime = nil
        isWaitingForNextChallenge = false
        currentChallengeIndex = 0
        
        let allChallenges = LivenessChallenge.allCases
        challenges = Array(allChallenges.shuffled().prefix(totalChallenges))
    }

    func validate(anchor: ARFaceAnchor) -> LivenessStatus {
        if !isGeometryAuthentic(geometry: anchor.geometry) {
            return .failure("Wajah kurang jelas. Coba pencahayaan lebih baik.")
        }
        
        if validationStartTime == nil {
            validationStartTime = Date()
            challengeStartTime = Date()
        }
        
        if let startTime = validationStartTime,
           Date().timeIntervalSince(startTime) > validationTimeout {
            let reason = "Waktu habis. Coba lagi."
            reset()
            return .failure(reason)
        }
        
        guard currentChallengeIndex < challenges.count else {
            return .success
        }
        
        if isWaitingForNextChallenge {
            return .validating(challenge: challenges[currentChallengeIndex])
        }
        
        let currentChallenge = challenges[currentChallengeIndex]
        
        if let challengeStart = challengeStartTime,
           Date().timeIntervalSince(challengeStart) > challengeTimeout {
            let reason = "Tantangan \(currentChallengeIndex + 1) gagal. Coba lagi."
            reset()
            return .failure(reason)
        }
        
        if check(challenge: currentChallenge, anchor: anchor) {
            currentChallengeIndex += 1
            isWaitingForNextChallenge = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isWaitingForNextChallenge = false
                self.challengeStartTime = Date()
            }
            
            return .challengeCompleted
        }
        
        return .validating(challenge: currentChallenge)
    }
    
    private func check(challenge: LivenessChallenge, anchor: ARFaceAnchor) -> Bool {
        switch challenge {
        case .blink:
            let leftBlinkValue = anchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0
            let rightBlinkValue = anchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0
            return leftBlinkValue > 0.6 && rightBlinkValue > 0.6
            
        case .smile:
            let leftSmileValue = anchor.blendShapes[.mouthSmileLeft]?.floatValue ?? 0
            let rightSmileValue = anchor.blendShapes[.mouthSmileRight]?.floatValue ?? 0
            return leftSmileValue > 0.4 && rightSmileValue > 0.4
            
        case .turnHeadLeft:
            let headYaw = anchor.transform.eulerAngles.y
            return headYaw > 0.4
            
        case .turnHeadRight:
            let headYaw = anchor.transform.eulerAngles.y
            return headYaw < -0.4
        }
    }
    
    private func isGeometryAuthentic(geometry: ARFaceGeometry) -> Bool {
        let vertices = geometry.vertices
        guard vertices.count > 1 else { return false }

        let zValues = vertices.map { $0.z }
        let meanZ = zValues.reduce(0, +) / Float(zValues.count)
        let variance = zValues.reduce(0, { $0 + ($1 - meanZ) * ($1 - meanZ) }) / Float(zValues.count)
        let standardDeviation = sqrt(variance)
        
        let minimumStandardDeviation: Float = 0.005
        return standardDeviation > minimumStandardDeviation
    }
    
    func getCurrentChallengeInfo() -> (current: Int, total: Int) {
        return (currentChallengeIndex + 1, totalChallenges)
    }
}

extension simd_float4x4 {
    var eulerAngles: SIMD3<Float> {
        let sy = sqrt(self.columns.0.x * self.columns.0.x + self.columns.1.x * self.columns.1.x)
        let singular = sy < 1e-6
        var x, y, z: Float
        if !singular {
            x = atan2(self.columns.2.y, self.columns.2.z)
            y = atan2(-self.columns.2.x, sy)
            z = atan2(self.columns.1.x, self.columns.0.x)
        } else {
            x = atan2(-self.columns.1.z, self.columns.1.y)
            y = atan2(-self.columns.2.x, sy)
            z = 0
        }
        return SIMD3<Float>(x, y, z)
    }
}

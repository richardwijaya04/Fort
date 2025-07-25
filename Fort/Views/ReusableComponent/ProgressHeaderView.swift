//
//  ProgressHeaderView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 23/07/25.
//

import SwiftUI

/// Enum untuk setiap langkah dalam proses onboarding.
enum OnboardingStep: String, CaseIterable {
    case ktp = "KTP"
    case dataDiri = "Data Diri"
    case pekerjaan = "Pekerjaan"
    case bank = "Bank"
    case kontak = "Kontak"
    case verifikasiWajah = "Verifikasi\nWajah"
}

/// Component View untuk menampilkan progress bar di bagian atas.
struct ProgressHeaderView: View {
    let currentStep: OnboardingStep
    private let allSteps = OnboardingStep.allCases

    var body: some View {
        VStack {
            // Baris untuk lingkaran dan garis
            HStack(spacing: 0) {
                ForEach(allSteps.indices, id: \.self) { index in
                    let step = allSteps[index]
                    
                    ZStack {
                        Circle()
                            .stroke(isStepCompleted(step) ? Color.lime : Color.gray.opacity(0.3), lineWidth: 2)
                            .frame(width: 12, height: 12)
                        
                        if isStepCompleted(step) {
                            Circle()
                                .fill(Color.lime)
                                .frame(width: 6, height: 6)
                        }
                    }

                    if index < allSteps.count - 1 {
                        Rectangle()
                            .fill(isStepCompleted(step) ? Color.lime : Color.gray.opacity(0.3))
                            .frame(height: 2)
                    }
                }
            }

            // Baris untuk teks label
            HStack {
                ForEach(allSteps, id: \.self) { step in
                    Text(step.rawValue)
                        .font(.caption2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(isStepCurrentOrCompleted(step) ? .primary : .secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 4)
        }
    }
    
    private func isStepCompleted(_ step: OnboardingStep) -> Bool {
        guard let currentIndex = allSteps.firstIndex(of: currentStep),
              let stepIndex = allSteps.firstIndex(of: step) else {
            return false
        }
        return stepIndex <= currentIndex
    }
    
    private func isStepCurrentOrCompleted(_ step: OnboardingStep) -> Bool {
        guard let currentIndex = allSteps.firstIndex(of: currentStep),
              let stepIndex = allSteps.firstIndex(of: step) else {
            return false
        }
        return stepIndex <= currentIndex
    }
}

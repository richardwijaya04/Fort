//
//  MainFlowView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 23/07/25.
//

import SwiftUI

enum FlowStep: Int, CaseIterable {
    case liveness = 0
    case content = 1
    case step3 = 2
    case step4 = 3
    
    var title: String {
        switch self {
        case .liveness: return "Verifikasi Wajah"
        case .content: return "Content"
        case .step3: return "Step 3"
        case .step4: return "Step 4"
        }
    }
}

struct MainPersonalIdentityFlowView: View {
    @State private var currentStep: Int = 0
    private let stepsNum: Int = 6
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Fixed Progress Bar at top
                VStack(spacing: 20) {
                    Divider()
                    ProgressBar(
                        stepsNum: stepsNum,
                        currentStep: $currentStep
                    )
                    .padding(.horizontal, 32)
                    .animation(.easeInOut(duration: 0.5), value: currentStep)
                }
                .background(Color(.systemBackground))
                .zIndex(1)
                
                // Content Area with smooth transitions
                ZStack {
                    Group {
                        switch FlowStep(rawValue: currentStep) {
                        case .liveness:
                            LivenessView(
                                onNext: { goToNext() },
                                onPrevious: { goToPrevious() }
                            )
                        case .content:
                            ContentView(
                                onNext: { goToNext() },
                                onPrevious: { goToPrevious() }
                            )
                        default:
                            LivenessView(
                                onNext: { goToNext() },
                                onPrevious: { goToPrevious() }
                            )
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(FlowStep(rawValue: currentStep)?.title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "chevron.backward") {
                        // Handle back action
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }
    
    private func goToNext() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentStep < stepsNum - 1 {
                currentStep += 1
            }
        }
    }
    
    private func goToPrevious() {
        withAnimation(.easeInOut(duration: 0.5)) {
            if currentStep > 0 {
                currentStep -= 1
            }
        }
    }
}

#Preview {
    MainPersonalIdentityFlowView()
}

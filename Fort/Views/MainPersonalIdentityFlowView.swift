//
//  MainFlowView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 23/07/25.
//
import SwiftUI

enum FlowState: Int, CaseIterable {
    case liveness = 0
    case content = 1
    case step3 = 2
    case step4 = 3
    case step5 = 4
    case step6 = 5
    
    var title: String {
        switch self {
        case .liveness: return "Verifikasi Wajah"
        case .content: return "Content"
        case .step3: return "Step 3"
        case .step4: return "Step 4"
        case .step5: return "Step 5"
        case .step6: return "Step 6"
        }
    }
}

struct MainPersonalIdentityFlowView: View {
    @State private var flowState: FlowState = .liveness
    @State private var showSuccessView = false
    @State private var showFailedView = false
    @State private var livenessResetID = UUID()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !showSuccessView && !showFailedView {
                    VStack(spacing: 20) {
                        Divider()
                        ProgressBar(
                            stepsNum: FlowState.allCases.count,
                            currentStep: .constant(flowState.rawValue)
                        )
                        .padding(.horizontal, 32)
                        .animation(.easeInOut(duration: 0.5), value: flowState)
                    }
                    .background(Color(.systemBackground))
                    .zIndex(1)
                }
                
                ZStack {
                    switch flowState {
                    case .liveness:
                        LivenessView(
                            onSuccess: { showSuccessView = true },
                            onFailure: { showFailedView = true }
                        ).id(livenessResetID)
                    case .content:
                        LivenessView(
                            onSuccess: { showSuccessView = true },
                            onFailure: { showFailedView = true }
                        ).id(livenessResetID)
//                        ContentView(
//                            onNext: { withAnimation { flowState = .step3 } },
//                            onPrevious: { withAnimation { flowState = .liveness } }
//                        )
                    case .step3:
                        StepView(title: "Step 3", onNext: { withAnimation{ flowState = .step4 } }, onPrevious: { withAnimation{ flowState = .content } })
                        
                    case .step4:
                        StepView(title: "Step 4", onNext: { withAnimation{ flowState = .step5 } }, onPrevious: { withAnimation{ flowState = .step3 } })
                        
                    case .step5:
                        StepView(title: "Step 5", onNext: { withAnimation{ flowState = .step6 } }, onPrevious: { withAnimation{ flowState = .step4 } })
                        
                    case .step6:
                        StepView(title: "Step 6", onNext: { print("Alur Selesai") }, onPrevious: { withAnimation{ flowState = .step5 } })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(flowState.title)
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
        .fullScreenCover(isPresented: $showSuccessView) {
            SuccessVerificationView(onCompletion: {
                showSuccessView = false
                withAnimation {
                    flowState = .content
                }
            })
        }
        .fullScreenCover(isPresented: $showFailedView) {
            FailedVerificationView(onRetry: {
                showFailedView = false
                livenessResetID = UUID()
            })
        }
    }
}


// MARK: Sementara aja, nanti ganti pake button yg sesuai sama screen
struct StepView: View {
    let title: String
    let onNext: () -> Void
    let onPrevious: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
            HStack {
                Button("Previous", action: onPrevious)
                Button("Next", action: onNext)
            }
            .padding()
        }
    }
}

#Preview {
    MainPersonalIdentityFlowView()
}

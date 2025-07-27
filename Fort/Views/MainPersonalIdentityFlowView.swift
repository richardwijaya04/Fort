//
//  MainFlowView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 23/07/25.
//

import SwiftUI

enum FlowState: Int, CaseIterable {
    case ocr = 0
    case personalInfo = 1
    case personalJobInfo = 2
    case bankInfo = 3
    case contactInfo = 4
    case liveness = 5
    
    var title: String {
        switch self {
        case .ocr: return "Foto KTP"
        case .personalInfo: return "Data Diri"
        case .personalJobInfo: return "Pekerjaan"
        case .bankInfo: return "Bank"
        case .contactInfo: return "Kontak"
        case .liveness: return "Verifikasi Wajah"
        }
    }
}

struct MainPersonalIdentityFlowView: View {
    @State private var flowState: FlowState = .ocr
    @State private var showSuccessView = false
    @State private var showFailedView = false
    @State private var livenessResetID = UUID()
    @State private var ocrResult: OCRResult = OCRResult()
    @State private var navigateToHome = false
    
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
                    case .ocr:
                        OCRViewWrapper(
                            ocrResult: $ocrResult,
                            onNext: { withAnimation { flowState = .personalInfo } }
                        )
                        
                    case .personalInfo:
                        PersonalInfoViewWrapper(
                            ocrResult: ocrResult,
                            onNext: { withAnimation { flowState = .personalJobInfo } },
                            onPrevious: { withAnimation { flowState = .ocr } }
                        )
                        
                    case .personalJobInfo:
                        PersonalJobInfoViewWrapper(
                            onNext: { withAnimation { flowState = .bankInfo } },
                            onPrevious: { withAnimation { flowState = .personalInfo } }
                        )
                        
                    case .bankInfo:
                        BankInfoViewWrapper(
                            onNext: { withAnimation { flowState = .contactInfo } },
                            onPrevious: { withAnimation { flowState = .personalJobInfo } }
                        )
                        
                    case .contactInfo:
                        ContactInfoViewWrapper(
                            onNext: { withAnimation { flowState = .liveness } },
                            onPrevious: { withAnimation { flowState = .bankInfo } }
                        )
                        
                    case .liveness:
                        LivenessView(
                            onSuccess: {
                                showSuccessView = true
                                // Navigate to Home after success overlay
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    navigateToHome = true
                                }
                            },
                            onFailure: { showFailedView = true }
                        ).id(livenessResetID)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle(flowState.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back", systemImage: "chevron.backward") {
                        handleBackNavigation()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showFailedView) {
                FailedVerificationView(onRetry: {
                showFailedView = false
                livenessResetID = UUID()
            })
        }
        .fullScreenCover(isPresented: $navigateToHome) {
            HomeView()
        }
    }
    
    private func handleBackNavigation() {
        withAnimation {
            switch flowState {
            case .ocr:
                // Handle going back to PIN creation or previous screen
                break
            case .personalInfo:
                flowState = .ocr
            case .personalJobInfo:
                flowState = .personalInfo
            case .bankInfo:
                flowState = .personalJobInfo
            case .contactInfo:
                flowState = .bankInfo
            case .liveness:
                flowState = .contactInfo
            }
        }
    }
}

// MARK: - Wrapper Views
struct OCRViewWrapper: View {
    @Binding var ocrResult: OCRResult
    let onNext: () -> Void
    @StateObject private var visionManager = VisionManager()
    @StateObject private var viewModel: OCRCameraViewModel
    
    init(ocrResult: Binding<OCRResult>, onNext: @escaping () -> Void) {
        self._ocrResult = ocrResult
        self.onNext = onNext
        let vision = VisionManager()
        _viewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
    }
    
    var body: some View {
        OCRView(visionManager: visionManager, viewModel: viewModel, onNext: onNext)
            .onChange(of: viewModel.isOCRConfirmed) { _, isConfirmed in
                if isConfirmed {
                    ocrResult = viewModel.resultOCR ?? OCRResult()
                    onNext()
                }
            }
    }
}

struct PersonalInfoViewWrapper: View {
    let ocrResult: OCRResult
    let onNext: () -> Void
    let onPrevious: () -> Void
    @StateObject private var viewModel: PersonalInfoViewModel
    
    init(ocrResult: OCRResult, onNext: @escaping () -> Void, onPrevious: @escaping () -> Void) {
        self.ocrResult = ocrResult
        self.onNext = onNext
        self.onPrevious = onPrevious
        _viewModel = StateObject(wrappedValue: PersonalInfoViewModel(ocrResult: ocrResult))
    }
    
    var body: some View {
        PersonalInfoView(viewModel: viewModel, onNext: onNext)
    }
}

struct PersonalJobInfoViewWrapper: View {
    let onNext: () -> Void
    let onPrevious: () -> Void
    @StateObject private var viewModel = PersonalJobInfoViewModel()
    
    var body: some View {
        PersonalJobInfoView(viewModel: viewModel, onNext: onNext)
    }
}

struct BankInfoViewWrapper: View {
    let onNext: () -> Void
    let onPrevious: () -> Void
    @StateObject private var viewModel = BankInfoViewModel()
    
    var body: some View {
        BankInfoView(onNext: onNext)
    }
}

struct ContactInfoViewWrapper: View {
    let onNext: () -> Void
    let onPrevious: () -> Void
    @StateObject private var viewModel = ContactInfoViewModel()
    
    var body: some View {
        ContactInfoView(onNext: onNext)
    }
}

#Preview {
    MainPersonalIdentityFlowView()
}

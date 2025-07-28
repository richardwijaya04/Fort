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
    
    @StateObject private var visionManager = VisionManager()
    @StateObject private var ocrViewModel: OCRCameraViewModel
    
    init() {
        let vision = VisionManager()
        _visionManager = StateObject(wrappedValue: vision)
        _ocrViewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                onNext: { withAnimation { flowState = .personalInfo } },
                                visionManager: visionManager,
                                viewModel: ocrViewModel
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
                if ocrViewModel.isProcessing {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    ProgressView()
                } else if ocrViewModel.isShowErrorAlert {
                    // (Anda bisa pindahkan UI Error Alert ke sini juga jika mau)
                    Color.black.opacity(0.5).ignoresSafeArea()
                    OCRFailedAlertView(viewModel: ocrViewModel)

                } else if ocrViewModel.isShowConfirmationAlert && ocrViewModel.resultOCR != nil {
                    // (Pindahkan UI Confirmation Alert ke sini juga)
                    Color.black.opacity(0.5).ignoresSafeArea()
                    OCRConfirmationAlertView(viewModel: ocrViewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showFailedView) {
            FailedVerificationView(onRetry: {
                showFailedView = false
                livenessResetID = UUID()
                navigateToHome = false
            })
        }
        .fullScreenCover(isPresented: $showSuccessView) {
            SuccessVerificationView(onCompletion: {
                showSuccessView = false
                navigateToHome = true
                flowState = .ocr // Reset flow state to start over
            })
        }
        // navigation after verif success
        .navigationDestination(isPresented: $navigateToHome) {
            HomeView()
        }
        .navigationBarBackButtonHidden(true)
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

// MARK: - Confirmation Text Field
struct OCRFailedAlertView: View {
    @ObservedObject var viewModel: OCRCameraViewModel

    var body: some View {
            ZStack {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                VStack (spacing: 25) {
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red)
                    
                    VStack (spacing: 36){
                        VStack (spacing: 5){
                            Text("KTP Tidak Terdeteksi")
                                .font(.system(size: 24, weight: .semibold))
                            
                            Text("Pastikan KTP berada di dalam bingkai")
                                .font(.system(size: 14, weight: .regular))
                        }
                        ErrorButton(text: "Foto Ulang") {
                            viewModel.isShowErrorAlert.toggle()
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .padding(.horizontal, 30)
            }
        }
}


// MARK: - Confirmation Alert for OCR KTP
struct OCRConfirmationAlertView: View {
    @ObservedObject var viewModel: OCRCameraViewModel
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var body: some View {
        ZStack {
            // Background semi-transparan
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    if keyboardObserver.isKeyboardVisible {
                        hideKeyboard()
                    } else {
                        viewModel.toggleConfirmationAlert()
                    }
                }

            // Konten Modal
            VStack(spacing: 10) {
                Text("Konfirmasi Data KTP")
                    .font(.system(size: 25, weight: .bold))
                    .padding(.bottom, 15)

                ConfirmationTextField(text: $viewModel.confirmationName, title: "Nama Lengkap")
                ConfirmationTextField(text: $viewModel.confirmationNIK, title: "NIK")
                ConfirmationTextField(text: $viewModel.confirmationBirthDate, title: "Tanggal Lahir", placeholder: "contoh : 12/08/1990", keyboardType: .numberPad)
                    .padding(.bottom, 15)
                
                PrimaryButton(text: "Konfirmasi") {
                    // Tombol ini HANYA mengubah state.
                    // Navigasi akan ditangani oleh .onChange di OCRViewWrapper
                    viewModel.isShowConfirmationAlert = false
                    viewModel.isOCRConfirmed = true
                    
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .padding(.horizontal, 25)
            .onTapGesture {
                if keyboardObserver.isKeyboardVisible {
                    hideKeyboard()
                }
            }
            .onChange(of: viewModel.confirmationBirthDate) { oldValue, newValue in
                viewModel.formatBirthDate(newValue: newValue, oldValue: oldValue)
            }
        }
    }
}

// MARK: - Wrapper Views
struct OCRViewWrapper: View {
    @Binding var ocrResult: OCRResult
    let onNext: () -> Void
    @ObservedObject var visionManager: VisionManager
    @ObservedObject var viewModel: OCRCameraViewModel

//    init(ocrResult: Binding<OCRResult>, onNext: @escaping () -> Void) {
//        self._ocrResult = ocrResult
//        self.onNext = onNext
//        let vision = VisionManager()
//        _viewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
//    }
    
    var body: some View {
        OCRView(visionManager: visionManager, viewModel: viewModel, onNext: onNext)
            .onChange(of: viewModel.isOCRConfirmed) { _, isConfirmed in
                if isConfirmed {
                    self.ocrResult = viewModel.resultOCR ?? OCRResult()
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

//
//  OCRView.swift
//  Fort
//
//  Created by William on 20/07/25.
//

import Foundation
import SwiftUI

struct OCRView: View {
    
    @StateObject var visionManager : VisionManager
    @StateObject var viewModel : OCRCameraViewModel
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    init() {
        let vision = VisionManager()
        _visionManager = StateObject(wrappedValue: vision)
        _viewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PersonalInfoView(ocrResult: viewModel.resultOCR ?? OCRResult()), isActive: $viewModel.isOCRConfirmed) {
                    EmptyView()
                }
                .hidden()
            
            VStack {
                VStack(spacing: 25) {
                    
                    VStack (alignment: .leading, spacing: 4) {
                        Text("Verifikasi Identitas Anda")
                            .font(.title3)
                            .bold()
                        
                        Text("Pastikan Anda sejajar dengan bingkai dan terbaca dengan jelas untuk proses verifikasi")
                            .font(.system(size: 14, weight: .regular))
                            .multilineTextAlignment(.leading)
                    }
                    
                    OCRCameraView(viewModel: viewModel)
                        .frame(maxWidth: .infinity, maxHeight: 214)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("Primary") ,lineWidth: 3)
                        )
                        .shadow(radius: 10)
                    
                    PrimaryButton(text: "Ambil Foto") {
                        viewModel.processOnCapturePhotoButtonClicked()
                    }
                    
                    VStack (spacing: 5) {
                        Text("Contoh KTP yang sesuai")
                            .font(.system(size: 17, weight: .semibold))
                        Image("ContohKTPOCR")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 289.95, height: 185.34)
                        Text("Foto dan NIK terlihat Jelas")
                            .font(.system(size: 13, weight: .medium))
                    }
                    
                }
                .padding(.horizontal, 32)
            }
            
            // second layer for custom alert
            if (viewModel.isProcessing){
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView()
            }
            else if viewModel.isShowErrorAlert {
                Color.black.opacity(0.5).ignoresSafeArea()
                
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
            else if viewModel.isShowConfirmationAlert && viewModel.resultOCR != nil {
                Color.black.opacity(0.5).ignoresSafeArea()
//                    .contentShape(Rectangle()) // ensures full-tap coverage
                    .onTapGesture {
                        if keyboardObserver.isKeyboardVisible {
                            hideKeyboard()
                        } else {
                            viewModel.toggleConfirmationAlert()
                        }
                    }

                
                VStack (spacing: 10) {
                    Text("Konfirmasi Data KTP")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.bottom, 15)
                    
                    ConfirmationTextField(text: $viewModel.confirmationName ,title: "Nama Lengkap")
                    ConfirmationTextField(text: $viewModel.confirmationNIK , title: "NIK")
                    
                    ConfirmationTextField(text: $viewModel.confirmationBirthDate, title: "Tanggal Lahir", placeholder: "contoh : 12/08/1990", keyboardType: .numberPad)
                        .padding(.bottom, 15)
                    
                    PrimaryButton(text: "Konfirmasi") {
                        viewModel.isOCRConfirmed.toggle()
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
            }
        }
        .onChange(of: viewModel.confirmationBirthDate) { oldValue, newValue in
            viewModel.formatBirthDate(newValue: newValue, oldValue: oldValue)
        }
        .navigationTitle(Text("Foto KTP"))
        .navigationBarTitleDisplayMode(.large)

    }
}


final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isKeyboardVisible = true
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isKeyboardVisible = false
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}


#Preview {
    OCRView()
}

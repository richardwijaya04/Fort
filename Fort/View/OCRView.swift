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
    
    init() {
        let vision = VisionManager()
        _visionManager = StateObject(wrappedValue: vision)
        _viewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
    }
    
    var body: some View {
        ZStack {
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
            .navigationTitle(Text("Foto KTP"))
            .navigationBarTitleDisplayMode(.large)
            
            // second layer for custom alert
            if (viewModel.isProcessing){
                Color.black.opacity(0.5).ignoresSafeArea()
                ProgressView()
            }
            else if viewModel.isShowConfirmationAlert && viewModel.resultOCR != nil {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        viewModel.toggleConfirmationAlert()
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
                        
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .padding(.horizontal, 25)
            }
        }
        .onChange(of: viewModel.confirmationBirthDate) { oldValue, newValue in
            viewModel.formatBirthDate(newValue: newValue, oldValue: oldValue)
        }
        
    }
}


#Preview {
    OCRView()
}

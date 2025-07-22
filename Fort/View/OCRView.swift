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
                                .stroke(visionManager.borderColor ,lineWidth: 3)
                        )
                        .shadow(radius: 10)
                    
                    PrimaryButton(text: "Ambil Foto") {
                        viewModel.processOnCapturePhotoButtonClicked(state: visionManager.borderColor)
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
            if (viewModel.isShowConfirmationAlert){
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        viewModel.toggleConfirmationAlert()
                    }
                
                VStack (spacing: 10) {
                    Text("Konfirmasi Data KTP")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.bottom, 15)
                    
                    ConfirmationTextField(text: .constant(""), placeholder: "Nama Lengkap")
                    ConfirmationTextField(text: .constant(""), placeholder: "NIK")
                    
                    ConfirmationTextField(text: .constant(""), placeholder: "Tanggal Lahir", icon: "calendar", isDisabled: true) {
                        
                    }
                        .padding(.bottom, 15)
                    
                    PrimaryButton(text: "Konfirmasi") {
                        
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .padding(.horizontal, 25)
            }
        }
    }
}

#Preview {
    OCRView()
}

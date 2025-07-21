//
//  OCRView.swift
//  Fort
//
//  Created by William on 20/07/25.
//

import Foundation
import SwiftUI

struct OCRView: View {
    
    @StateObject var visionController : VisionController
    @StateObject var viewModel : OCRCameraViewModel
    
    init() {
        let vision = VisionController()
        _visionController = StateObject(wrappedValue: vision)
        _viewModel = StateObject(wrappedValue: OCRCameraViewModel(visionController: vision))
    }
    
    var body: some View {
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
                            .stroke(visionController.borderColor ,lineWidth: 3)
                    )
                    .shadow(radius: 10)
                
                Button {
                    
                } label: {
                    Text("Ambil Foto")
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .bold()
                        .background(RoundedRectangle(cornerRadius:  10).fill(Color("Primary")))
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
                    
                    ///Debug
//                    if let img = visionController.image {
//                        Image(uiImage: img)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    }
                    
                    
                }
                
            }
            .padding(.horizontal, 32)
            
            
        }
        .navigationTitle(Text("Foto KTP"))
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    OCRView()
}

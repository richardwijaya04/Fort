//
//  PINCreationFlowView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct PINCreationFlowView: View {
    @StateObject private var viewModel = PINViewModel()
    @Binding var isPINCreationComplete: Bool
    @FocusState private var isKeyboardFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. Judul besar di kiri atas
            Text(viewModel.viewTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            // 2. Konten utama
            VStack(alignment: .center, spacing: 20) {
                Text(viewModel.viewSubtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ZStack {
                    PINInputView(
                        pin: viewModel.pin,
                        pinLength: viewModel.pinLength,
                        hasError: viewModel.pinMismatchError
                    )
                    
                    TextField("", text: $viewModel.pin)
                        .keyboardType(.numberPad)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .focused($isKeyboardFocused)
                    // Ganti blok .onChange yang lama dengan yang ini:
                    .onChange(of: viewModel.pin) { newValue in
                        if !newValue.isEmpty && viewModel.pinMismatchError {
                            viewModel.pinMismatchError = false
                        }
                        
                        // Proses jika panjang PIN sudah 6 digit
                        if newValue.count == viewModel.pinLength {
                            viewModel.processPinEntry()
                        }
                    }
                }
                .onTapGesture {
                    isKeyboardFocused = true
                }
                
                // Tampilan pesan error ini sekarang akan muncul dengan andal
                if viewModel.pinMismatchError {
                    Text("PIN tidak cocok. Silakan coba lagi.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity) // Animasi halus
                }

                // 3. Teks informasi dengan alignment yang sudah disesuaikan
                VStack(alignment: .center, spacing: 8) {
                    Text("Gunakan PIN untuk keamanan transaksi Anda")
                        .multilineTextAlignment(.center)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Pastikan kamu mengingat PIN ini")
                        Text("• Rahasiakan PIN dari siapa pun")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top)
            }
            
            Spacer() // Mendorong semua konten ke atas
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            isKeyboardFocused = true
        }
        .onChange(of: viewModel.flowState) { newState in
            if newState == .finished {
                isPINCreationComplete = true
            } else if newState == .confirming {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isKeyboardFocused = true
                }
            }
        }
    }
}

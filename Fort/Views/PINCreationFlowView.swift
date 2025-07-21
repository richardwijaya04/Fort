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
            // 1. Judul besar di kiri atas, persis seperti desain
            Text(viewModel.viewTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40) // Jarak antara judul dan konten

            // 2. Konten di-center secara horizontal
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
                        .onChange(of: viewModel.pin) { newValue in
                            if newValue.count > viewModel.pinLength {
                                viewModel.pin = String(newValue.prefix(viewModel.pinLength))
                            }
                            if viewModel.pin.count == viewModel.pinLength {
                                viewModel.processPinEntry()
                            }
                            if viewModel.pinMismatchError {
                                viewModel.pinMismatchError = false
                            }
                        }
                }
                .onTapGesture {
                    isKeyboardFocused = true
                }
                
                if viewModel.pinMismatchError {
                    Text("PIN tidak cocok. Silakan coba lagi.")
                        .font(.caption)
                        .foregroundColor(.red)
                }

                // 3. Teks informasi di bawah input PIN
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Gunakan PIN untuk keamanan transaksi Anda")
                    Text("• Pastikan kamu mengingat PIN ini")
                    Text("• Rahasiakan PIN dari siapa pun")
                }
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            }
            
            Spacer() // Mendorong semua konten ke atas
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline) // Kita akan mengontrol judul secara manual
        .navigationBarBackButtonHidden(false) // Pastikan tombol back terlihat
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

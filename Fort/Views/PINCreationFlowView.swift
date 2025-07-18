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

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // JUDUL UTAMA
            Text(viewModel.viewTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
                .padding(.top, 20)

            Spacer().frame(height: 60)

            // KONTEN TENGAH
            VStack(spacing: 16) {
                Text(viewModel.viewSubtitle)
                    .font(.headline)
                    .fontWeight(.regular)

                PINInputView(pin: viewModel.pin, pinLength: viewModel.pinLength, hasError: viewModel.pinMismatchError)

                if viewModel.pinMismatchError {
                    Text("PIN tidak cocok. Silakan coba lagi.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                // Teks Informasi dengan Bullet Points
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Gunakan PIN untuk keamanan transaksi Anda")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Pastikan kamu mengingat PIN ini")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Rahasiakan PIN dari siapa pun")
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.top, 24)

            }

            Spacer()

            // KEYBOARD
            NumericKeypadView(
                onDigitTapped: viewModel.appendDigit,
                onDeleteTapped: viewModel.deleteDigit,
                onSpecialKeyTapped: {
                    // Fungsi untuk tombol +*# (opsional)
                    print("Tombol spesial ditekan")
                }
            )
            .padding(.bottom)
        }
        .navigationBarHidden(true) // Sembunyikan navigation bar bawaan untuk kontrol penuh
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onChange(of: viewModel.flowState) { newState in
            if newState == .finished {
                isPINCreationComplete = true
            }
        }
        .animation(.default, value: viewModel.pinMismatchError)
        .animation(.default, value: viewModel.flowState)
    }
}

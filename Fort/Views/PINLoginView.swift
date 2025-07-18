//
//  PINLoginView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct PINLoginView: View {
    @State private var pin: String = ""
    @State private var errorMessage: String?
    @Binding var isPINSet: Bool

    private let pinLength = 6

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Masukkan PIN Anda")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            PINInputView(pin: pin, pinLength: pinLength, hasError: errorMessage != nil)
                .onChange(of: pin) { newValue in
                    if newValue.count == pinLength {
                        validatePIN()
                    }
                    if errorMessage != nil {
                        errorMessage = nil
                    }
                }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            // PERBAIKAN DI SINI
            NumericKeypadView(
                onDigitTapped: { digit in
                    guard pin.count < pinLength else { return }
                    pin += digit
                },
                onDeleteTapped: {
                    guard !pin.isEmpty else { return }
                    pin.removeLast()
                },
                onSpecialKeyTapped: {
                    // Tombol ini tidak memiliki fungsi di halaman login, jadi kita kosongkan.
                }
            )
            
            Button("Lupa PIN?") {
                KeychainService.shared.deletePin()
                isPINSet = false
            }
            .padding()
        }
        .padding()
        .navigationTitle("Login")
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func validatePIN() {
        let savedPIN = KeychainService.shared.retrievePin()
        if pin == savedPIN {
            errorMessage = nil
            print("✅ Login Berhasil!")
            // Di sini Anda akan menavigasikan user ke dashboard atau halaman utama aplikasi
        } else {
            errorMessage = "PIN salah. Silakan coba lagi."
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.pin = "" // Reset PIN setelah error
            }
        }
    }
}

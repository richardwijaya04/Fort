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
    @FocusState private var isKeyboardFocused: Bool

    private let pinLength = 6

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Judul besar di kiri atas
            Text("Masukkan PIN")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            VStack(alignment: .center, spacing: 20) {
                Text("Untuk melanjutkan, masukkan PIN keamanan Anda.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ZStack {
                    PINInputView(pin: pin, pinLength: pinLength, hasError: errorMessage != nil)
                    
                    TextField("", text: $pin)
                        .keyboardType(.numberPad)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .focused($isKeyboardFocused)
                        .onChange(of: pin) { newValue in
                            if newValue.count > pinLength {
                                pin = String(newValue.prefix(pinLength))
                            }
                            if pin.count == pinLength {
                                validatePIN()
                            }
                            if errorMessage != nil {
                                errorMessage = nil
                            }
                        }
                }
                .onTapGesture {
                    isKeyboardFocused = true
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            
            // Tombol Lupa PIN di bagian bawah tengah
            HStack {
                Spacer()
                Button("Lupa PIN?") {
                    KeychainService.shared.deletePin()
                    isPINSet = false
                }
                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onAppear {
            isKeyboardFocused = true
        }
    }
    
    private func validatePIN() {
        let savedPIN = KeychainService.shared.retrievePin()
        if pin == savedPIN {
            errorMessage = nil
            print("✅ Login Berhasil!")
        } else {
            errorMessage = "PIN salah. Silakan coba lagi."
            #if os(iOS)
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            #endif
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.pin = ""
                self.isKeyboardFocused = true
            }
        }
    }
}

//
//  PINLoginView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct PINLoginView: View {
    @StateObject private var viewModel = PINLoginViewModel()
    @Binding var isPINSet: Bool
    @FocusState private var isKeyboardFocused: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Masukkan PIN")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            VStack(alignment: .center, spacing: 20) {
                Text("Untuk melanjutkan, masukkan PIN keamanan Anda.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ZStack {
                    PINInputView(pin: viewModel.pin, pinLength: 6, hasError: viewModel.errorMessage != nil && !viewModel.isLocked)
                    
                    TextField("", text: $viewModel.pin)
                        .keyboardType(.numberPad)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .focused($isKeyboardFocused)
                        .disabled(viewModel.isLocked) // Nonaktifkan input saat terkunci
                    // Ganti blok .onChange yang lama dengan yang ini:
                    .onChange(of: viewModel.pin) { newValue in
                        // Validasi jika panjang PIN sudah 6 digit
                        if newValue.count == 6 {
                            viewModel.validatePIN()
                        }
                    }
                }
                .onTapGesture {
                    if !viewModel.isLocked {
                        isKeyboardFocused = true
                    }
                }

                // Tampilan Pesan Error atau Cooldown
                if viewModel.isLocked {
                    Text(viewModel.cooldownMessage)
                        .font(.headline)
                        .foregroundColor(.orange)
                        .transition(.opacity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Lupa PIN?") {
                    KeychainService.shared.deletePin()
                    isPINSet = false
                }
                .disabled(viewModel.isLocked) // Nonaktifkan saat terkunci
                Spacer()
            }
            .padding(.bottom)
        }
        .padding()
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.body.weight(.medium))
                        Text("Back")
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            if !viewModel.isLocked {
                isKeyboardFocused = true
            }
        }
        .fullScreenCover(isPresented: $viewModel.navigateToHome) {
                    // Tujuan navigasi yang benar
                    HomeView()
                }
    }
}

//
//  LoanPinVerificationView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 25/07/25.
//


// Views/LoanPINVerificationView.swift

import SwiftUI

struct LoanPINVerificationView: View {
    @StateObject private var viewModel = LoanPINViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("PIN Keamanan Anda")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Masukkan 6 digit PIN anda untuk melanjutkan proses pinjaman dengan aman")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            // Spacer untuk mendorong konten PIN ke tengah, menyisakan ruang di bawah
            
            // Konten PIN
            VStack(spacing: 24) {
                ZStack {
                    PINInputView(
                        pin: viewModel.pin,
                        pinLength: 6,
                        hasError: viewModel.hasError
                    )
                    
                    TextField("", text: $viewModel.pin)
                        .keyboardType(.numberPad)
                        .foregroundColor(.clear)
                        .accentColor(.clear)
                        .focused($isKeyboardFocused)
                        .disabled(viewModel.isLocked)
                }
                .onTapGesture {
                    isKeyboardFocused = true
                }

                if viewModel.isLocked {
                    Text(viewModel.lockoutMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                } else {
                    Button("Lupa PIN Keamanan?") {
                        // Logika lupa PIN
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("Primary"))
                }
            }
            
            // Spacer utama yang mendorong semua konten ke atas
            Spacer()
            
            // Navigasi
            NavigationLink(
                destination: Text("Pengajuan Pinjaman Berhasil!"),
                isActive: $viewModel.navigateToSuccess,
                label: { EmptyView() }
            )
        }
        .onAppear {
            isKeyboardFocused = true
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}


#Preview {
    NavigationView {
        LoanPINVerificationView()
    }
}

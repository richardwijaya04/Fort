//
//  PINCreationFlowView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct PINCreationFlowView: View {
    @StateObject private var viewModel = PINViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
    @Binding var isPINCreationComplete: Bool
    @Environment(\.presentationMode) var presentationMode
    
    // State untuk mengontrol navigasi ke halaman OCR
    @State private var navigateToOCR = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.viewTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

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
                        .onChange(of: viewModel.pin) { _, newValue in
                            if !newValue.isEmpty && viewModel.pinMismatchError {
                                viewModel.pinMismatchError = false
                            }
                            if newValue.count == viewModel.pinLength {
                                viewModel.processPinEntry()
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
                        .transition(.opacity)
                }

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
            
            Spacer()
            
            // Link navigasi tersembunyi ke OCRView
            NavigationLink(
                destination: MainPersonalIdentityFlowView(),
                isActive: $navigateToOCR,
                label: { EmptyView() }
            )
            .hidden()
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline) // Disesuaikan agar lebih rapi
        .navigationBarBackButtonHidden(true)
        .toolbar {
             ToolbarItem(placement: .navigationBarLeading) {
                 if viewModel.flowState == .confirming {
                     Button(action: {
                         withAnimation {
                             viewModel.flowState = .creating
                             viewModel.pin = ""
                         }
                     }) {
                         HStack(spacing: 4) {
                             Image(systemName: "chevron.left")
                             Text("Kembali")
                         }
                         .foregroundStyle(.black)
                     }
                 }
             }
         }
        .onAppear {
            isKeyboardFocused = true
            
            if viewModel.flowState == .finished {
                viewModel.resetFlow()
            }
        }
        .onChange(of: viewModel.flowState) { _, newState in
            if newState == .finished {
                // Memicu navigasi saat PIN selesai dibuat
                navigateToOCR = true
            } else if newState == .confirming {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isKeyboardFocused = true
                }
            }
        }
    }
}

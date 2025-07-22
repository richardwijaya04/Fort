//
//  Verification.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 17/07/25.
//

import SwiftUI

struct Verification: View {
    
    @EnvironmentObject var otpModel: OTPViewModel
    @FocusState private var isTextFieldActive: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Kode OTP Sudah Terkirim ke Nomor")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                
                Text("+\(otpModel.code) \(otpModel.number)")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            VStack(spacing: 20) {
                
                OTPFieldView()
                
                HStack {
                    if otpModel.timeRemaining > 0 {
                        Text("Kirim Ulang Kode (\(otpModel.timeRemaining)s)")
                            .font(.callout)
                            .foregroundColor(.gray)
                    } else {
                        Button {
                            Task { await otpModel.sendOTP() }
                        } label: {
                            Text("Kirim Ulang")
                                .font(.callout)
                                .foregroundStyle(.lime)
                                .fontWeight(.semibold)
                                .underline(true, color: .lime)
                        }
                    }
                }
                
                Button {
                    Task { await otpModel.verifyOTP() }
                } label: {
                    Text ("Selanjutnya")
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.lime.opacity(isNextButtonDisabled() ? 0.5 : 1.0))
                        .cornerRadius(8)
                }
                .disabled(isNextButtonDisabled())
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                isTextFieldActive = true
            }
            .frame(minHeight: 200)
            
            Spacer()
        }
        .navigationTitle("Masukkan Kode OTP")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
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
        )
        .background(
            NavigationLink(
                destination: HomeView().environmentObject(otpModel),
                isActive: $otpModel.log_status
            ) {
                EmptyView()
            }
            .hidden()
        )
        .onChange(of: otpModel.otpText) { _, newValue in handleOTPChange(newValue: newValue) }
        .alert(isPresented: $otpModel.showAlert) {
            Alert(title: Text("Error"), message: Text(otpModel.errorMsg), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isTextFieldActive = true
            }
        }
    }
    
    private func isNextButtonDisabled() -> Bool {
        return otpModel.otpText.count != 6
    }
    
    private func handleOTPChange(newValue: String) {
        if newValue.count > 6 {
            otpModel.otpText = String(newValue.prefix(6))
        }
        
        let characters = Array(otpModel.otpText)
        for i in 0..<6 {
            otpModel.otpFields[i] = (i < characters.count) ? String(characters[i]) : ""
        }
    }
    
    @ViewBuilder
    private func OTPFieldView() -> some View {
        ZStack {
            TextField("", text: $otpModel.otpText)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isTextFieldActive)
            
            HStack(spacing: 10) {
                ForEach(0..<6, id: \.self) { index in
                    Text(otpModel.otpFields[index])
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.inputBox.opacity(0.5))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isTextFieldActive && otpModel.otpText.count == index ? .lime : Color.clear, lineWidth: 1.5)
                        )
                }
            }
        }
    }
}


#Preview {
    NavigationView {
        Verification()
            .environmentObject(OTPViewModel())
    }
}

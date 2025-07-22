//
//  Login.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 21/07/25.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var otpModel: OTPViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Masukkan Nomor HP Anda")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text("Pastikan nomor Handphone anda aktif dan dapat dihubungi untuk verifikasi akun")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Text("+62")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 1, height: 25)
                    
                    TextField("812 123 4567", text: $otpModel.number)
                        .keyboardType(.numberPad)
                        .font(.headline)
                        .onChange(of: otpModel.number) { _, newValue in
                            let sanitizedInput = sanitizePhoneNumber(newValue)
                            
                            let limitedInput = String(sanitizedInput.prefix(13))
                            
                            otpModel.number = formatPhoneNumber(limitedInput)
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lime, lineWidth: 2)
                )
                
                VStack(alignment: .leading, spacing: 15) {
                    Toggle(isOn: $otpModel.termsAccepted) {
                        Text("Saya sudah membaca dan setuju dengan Kebijakan Privasi, Ketentuan Pengguna, dan Disklosur Risiko dari EasyCash")
                            .font(.caption2)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    
                    Toggle(isOn: $otpModel.promotionsAccepted) {
                        Text("Saya setuju untuk menerima promosi dari EasyCash")
                            .font(.caption2)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                }
            
                Button {
                    Task { await otpModel.sendOTP() }
                } label: {
                    Text("Selanjutnya")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black.opacity(isButtonEnabled ? 1.0 : 0.5))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.lime.opacity(isButtonEnabled ? 1.0 : 0.5))
                        .cornerRadius(8)
                }
                .disabled(!isButtonEnabled)
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text("Diawasi Oleh:")
                    .font(.callout)
                    .fontWeight(.semibold)
                HStack {
                    Image("ojk").resizable().scaledToFit().frame(height: 36)
                    Image("afpi").resizable().scaledToFit().frame(height: 36)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard)
        .navigationTitle("Daftar Akun")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarHidden(false)
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
                destination: Verification().environmentObject(otpModel),
                isActive: $otpModel.isNavigatingToVerification
            ) {
                EmptyView()
            }
            .hidden()
        )
        .alert(isPresented: $otpModel.showAlert) {
            Alert(title: Text("Error"), message: Text(otpModel.errorMsg), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            otpModel.code = "62"
        }
    }
    
    private var isButtonEnabled: Bool {
        let cleanNumber = otpModel.number.replacingOccurrences(of: " ", with: "")
        return !cleanNumber.isEmpty &&
               (cleanNumber.count >= 9 && cleanNumber.count <= 13) &&
               otpModel.termsAccepted
    }
    
    private func sanitizePhoneNumber(_ input: String) -> String {
        let numbersOnly = input.filter { $0.isNumber }
        
        let cleanedNumber = numbersOnly.hasPrefix("0") ? String(numbersOnly.dropFirst()) : numbersOnly
        
        return cleanedNumber
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        var formatted = ""
        for (index, character) in number.enumerated() {
            if index == 3 || index == 7 {
                formatted += " "
            }
            formatted += String(character)
        }
        
        return formatted
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .lime : .gray)
                
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationView {
        Login()
            .environmentObject(OTPViewModel())
    }
}

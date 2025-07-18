//
//  OTPView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct OTPView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Halaman OTP")
                    .font(.largeTitle)
                Text("Masukkan kode OTP yang dikirimkan.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                NavigationLink("Verifikasi & Buat PIN") {
                    PINLoginOrCreationView()
                }
                .padding(.top, 40)
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Verifikasi OTP")
        }
    }
}

// Wrapper view untuk mengelola state navigasi
struct PINLoginOrCreationView: View {
    // FIX: Panggilan ke retrievePin() tidak lagi butuh 'try' dan pengecekan '!= nil'
    // sudah benar untuk tipe data opsional.
    @State private var isPINSet: Bool = KeychainService.shared.retrievePin() != nil
    
    var body: some View {
        if isPINSet {
            PINLoginView(isPINSet: $isPINSet)
        } else {
            PINCreationFlowView(isPINCreationComplete: $isPINSet)
        }
    }
}

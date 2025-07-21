//
//  OTPView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct OTPView: View {
    var body: some View {
        // NavigationStack diperlukan untuk mendapatkan tombol "Back" otomatis
        NavigationStack {
            VStack(spacing: 20) {
                // Konten halaman OTP Anda bisa ditaruh di sini
                Text("Halaman Verifikasi OTP")
                    .font(.title)
                
                // NavigationLink akan membawa pengguna ke alur PIN
                NavigationLink("Verifikasi & Lanjut ke PIN") {
                    PINLoginOrCreationView()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            .navigationTitle("Verifikasi OTP")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PINLoginOrCreationView: View {
    @State private var isPINSet: Bool = KeychainService.shared.retrievePin() != nil
    
    var body: some View {
        if isPINSet {
            PINLoginView(isPINSet: $isPINSet)
        } else {
            PINCreationFlowView(isPINCreationComplete: $isPINSet)
        }
    }
}

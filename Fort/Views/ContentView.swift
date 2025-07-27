//
//  ContentView.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 16/07/25.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
    // ViewModel ini tetap di sini untuk di-pass ke semua view di bawahnya
    @StateObject var otpModel = OTPViewModel()
    
    var body: some View {
        NavigationStack {
            // Langsung tampilkan HomeView sebagai halaman utama.
            // HomeView sendiri yang akan menentukan apa yang ditampilkan (kartu daftar, kartu limit, dll)
            HomeView()
        }
        // Pastikan OTPViewModel tersedia untuk semua child view (termasuk LoginView saat dipanggil nanti)
        .environmentObject(otpModel)
    }
}

#Preview {
    ContentView()
}

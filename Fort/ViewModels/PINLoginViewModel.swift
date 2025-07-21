//
//  PINLoginViewModel.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import Foundation
import Combine

class PINLoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var pin: String = ""
    @Published var errorMessage: String?
    @Published var incorrectAttempts: Int = 0
    @Published var isLocked: Bool = false
    @Published var remainingCooldown: Int = 0
    @Published var navigateToHome: Bool = false

    // MARK: - Private Properties
    private var cooldownTimer: Timer?
    private let maxAttempts = 3
    private let cooldownDuration = 60 // dalam detik

    // MARK: - Core Logic
    func validatePIN() {
        // Jangan proses jika sedang terkunci
        guard !isLocked else { return }

        let savedPIN = KeychainService.shared.retrievePin()

        if pin == savedPIN {
            // PIN Benar
            print("✅ Login Berhasil! Navigasi ke Home...")
            correctPinEntered()
        } else {
            // PIN Salah
            incorrectPinEntered()
        }
    }

    private func correctPinEntered() {
        self.errorMessage = nil
        self.incorrectAttempts = 0
        // Beri sedikit jeda sebelum navigasi agar terasa mulus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigateToHome = true
        }
    }

    private func incorrectPinEntered() {
        self.incorrectAttempts += 1
        
        if incorrectAttempts >= maxAttempts {
            // Sudah 3x salah, kunci akun
            self.errorMessage = "Terlalu banyak percobaan. Akun Anda dikunci sementara."
            self.pin = ""
            startCooldown()
        } else {
            // Masih ada kesempatan
            let attemptsLeft = maxAttempts - incorrectAttempts
            self.errorMessage = "PIN salah! Kesempatan tersisa: \(attemptsLeft)x."
            self.pin = "" // Kosongkan PIN agar user bisa coba lagi
        }
    }

    // MARK: - Cooldown Logic
    private func startCooldown() {
        self.isLocked = true
        self.remainingCooldown = cooldownDuration

        // Hentikan timer lama jika ada
        cooldownTimer?.invalidate()

        // Mulai timer baru
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.remainingCooldown > 0 {
                self.remainingCooldown -= 1
            } else {
                // Cooldown selesai, reset state
                self.resetLockout()
            }
        }
    }

    func resetLockout() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isLocked = false
        incorrectAttempts = 0
        errorMessage = nil
        pin = ""
    }
    
    // Helper untuk mengubah detik menjadi format "MM:SS"
    var cooldownMessage: String {
        let minutes = remainingCooldown / 60
        let seconds = remainingCooldown % 60
        return String(format: "Coba lagi dalam %02d:%02d", minutes, seconds)
    }
}

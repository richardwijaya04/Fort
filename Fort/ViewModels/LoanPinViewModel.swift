//
//  LoanPinViewModel.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 25/07/25.
//


// ViewModels/LoanPINViewModel.swift

import Foundation
import Combine

@MainActor
class LoanPINViewModel: ObservableObject {
    @Published var pin: String = "" {
        didSet {
            // Batasi panjang PIN maksimal 6 digit
            if pin.count > 6 {
                pin = String(pin.prefix(6))
            }
            
            // Jika PIN sudah 6 digit, langsung validasi
            if pin.count == 6 {
                validatePIN()
            }
            
            // Hapus status error setiap kali user mulai mengetik lagi
            if !pin.isEmpty && hasError {
                hasError = false
            }
        }
    }
    
    @Published var hasError: Bool = false
    @Published var incorrectAttempts: Int = 0
    @Published var isLocked: Bool = false
    @Published var remainingCooldown: Int = 0
    @Published var navigateToSuccess: Bool = false

    private var cooldownTimer: Timer?
    private let maxAttempts = 3
    private let cooldownDuration = 60 // 1 menit
    
    // MARK: - Core Logic

    private func validatePIN() {
        // Biarkan keyboard turun sedikit sebelum navigasi/error
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let savedPIN = KeychainService.shared.retrievePin()

            if self.pin == savedPIN {
                self.correctPinEntered()
            } else {
                self.incorrectPinEntered()
            }
        }
    }

    private func correctPinEntered() {
        self.hasError = false
        self.incorrectAttempts = 0
        print("✅ PIN Keamanan Benar. Melanjutkan proses pinjaman...")
        self.navigateToSuccess = true
    }

    private func incorrectPinEntered() {
        self.incorrectAttempts += 1
        
        if incorrectAttempts >= maxAttempts {
            startCooldown()
        } else {
            let attemptsLeft = maxAttempts - incorrectAttempts
            print("❌ PIN salah! Kesempatan tersisa: \(attemptsLeft)x.")
            self.pin = ""
            self.hasError = true
        }
    }

    // MARK: - Cooldown Logic
    
    private func startCooldown() {
        self.isLocked = true
        self.pin = ""
        self.hasError = true
        self.remainingCooldown = cooldownDuration
        
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.remainingCooldown > 0 {
                self.remainingCooldown -= 1
            } else {
                self.resetLockout()
            }
        }
    }

    func resetLockout() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isLocked = false
        incorrectAttempts = 0
        hasError = false
        pin = ""
    }
    
    var lockoutMessage: String {
        let minutes = remainingCooldown / 60
        let seconds = remainingCooldown % 60
        return String(format: "Terlalu banyak percobaan. Coba lagi dalam %02d:%02d", minutes, seconds)
    }
}

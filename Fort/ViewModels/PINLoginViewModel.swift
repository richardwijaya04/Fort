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
    
    // MARK: - Persistence Keys
    private let attemptsKey = "pinIncorrectAttempts"
    private let lockoutKey = "pinLockoutTimestamp"

    init() {
        // Cek status dari UserDefaults saat ViewModel dibuat
        checkPersistentState()
    }
    
    // MARK: - Core Logic
    func validatePIN() {
        guard !isLocked else { return }

        let savedPIN = KeychainService.shared.retrievePin()

        if pin == savedPIN {
            print("✅ Login Berhasil! Navigasi ke Home...")
            correctPinEntered()
        } else {
            incorrectPinEntered()
        }
    }

    private func correctPinEntered() {
        self.errorMessage = nil
        self.incorrectAttempts = 0
        // Hapus state dari UserDefaults karena sudah berhasil
        UserDefaults.standard.removeObject(forKey: attemptsKey)
        UserDefaults.standard.removeObject(forKey: lockoutKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigateToHome = true
        }
    }

    private func incorrectPinEntered() {
        self.incorrectAttempts += 1
        // Simpan jumlah percobaan ke UserDefaults
        UserDefaults.standard.set(self.incorrectAttempts, forKey: attemptsKey)
        
        if incorrectAttempts >= maxAttempts {
            // Kunci akun dan simpan timestamp kapan kunci akan terbuka
            let lockoutEndDate = Date().addingTimeInterval(TimeInterval(cooldownDuration))
            UserDefaults.standard.set(lockoutEndDate, forKey: lockoutKey)
            
            self.errorMessage = "Terlalu banyak percobaan. Akun Anda dikunci sementara."
            self.pin = ""
            startCooldown(endDate: lockoutEndDate)
        } else {
            let attemptsLeft = maxAttempts - incorrectAttempts
            self.errorMessage = "PIN salah! Kesempatan tersisa: \(attemptsLeft)x."
            self.pin = ""
        }
    }

    // MARK: - Cooldown & Persistence Logic
    
    /// Cek state dari UserDefaults saat app dibuka
    private func checkPersistentState() {
        let defaults = UserDefaults.standard
        self.incorrectAttempts = defaults.integer(forKey: attemptsKey)
        
        if let lockoutEndDate = defaults.object(forKey: lockoutKey) as? Date {
            // Jika ada timestamp lockout, cek apakah masih berlaku
            if Date() < lockoutEndDate {
                // Masih dalam periode cooldown, lanjutkan timer
                startCooldown(endDate: lockoutEndDate)
            } else {
                // Cooldown sudah lewat, reset semuanya
                resetLockout()
            }
        }
    }

    /// Memulai timer cooldown visual berdasarkan tanggal akhir
    private func startCooldown(endDate: Date) {
        self.isLocked = true
        
        // Hentikan timer lama jika ada
        cooldownTimer?.invalidate()

        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Hitung sisa waktu dari sekarang ke tanggal akhir
            let remaining = Int(endDate.timeIntervalSince(Date()))
            
            if remaining > 0 {
                self.remainingCooldown = remaining
            } else {
                // Cooldown selesai, reset state
                self.resetLockout()
            }
        }
        // Jalankan sekali di awal agar UI langsung update
        cooldownTimer?.fire()
    }

    func resetLockout() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isLocked = false
        incorrectAttempts = 0
        errorMessage = nil
        pin = ""
        
        // Hapus juga dari UserDefaults
        UserDefaults.standard.removeObject(forKey: attemptsKey)
        UserDefaults.standard.removeObject(forKey: lockoutKey)
    }
    
    var cooldownMessage: String {
        let minutes = remainingCooldown / 60
        let seconds = remainingCooldown % 60
        return String(format: "Coba lagi dalam %02d:%02d", minutes, seconds)
    }
}

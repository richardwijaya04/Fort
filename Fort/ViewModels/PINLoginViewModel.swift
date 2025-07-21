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
    @Published var pin: String = "" {
        didSet {
            // Filter untuk memastikan hanya angka yang bisa masuk
            let filtered = pin.filter { "0123456789".contains($0) }
            
            if pin != filtered {
                pin = filtered
            }
            
            // --- INI YANG DIBENERIN, KONTOL ---
            // Panjang PIN harusnya 6, bukan maxAttempts.
            let pinLength = 6
            if pin.count > pinLength {
                pin = String(pin.prefix(pinLength))
            }
            // --- UDAH BENER SEKARANG ---
        }
    }
    
    @Published var errorMessage: String?
    @Published var incorrectAttempts: Int = 0
    @Published var isLocked: Bool = false
    @Published var remainingCooldown: Int = 0
    @Published var navigateToHome: Bool = false

    // MARK: - Private Properties
    private var cooldownTimer: Timer?
    private let maxAttempts = 3 // INI BUAT HITUNGAN SALAH, BUKAN PANJANG PIN
    private let cooldownDuration = 60 // dalam detik
    
    private let attemptsKey = "pinIncorrectAttempts"
    private let lockoutKey = "pinLockoutTimestamp"

    init() {
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
        UserDefaults.standard.removeObject(forKey: attemptsKey)
        UserDefaults.standard.removeObject(forKey: lockoutKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigateToHome = true
        }
    }

    private func incorrectPinEntered() {
        self.incorrectAttempts += 1
        UserDefaults.standard.set(self.incorrectAttempts, forKey: attemptsKey)
        
        if incorrectAttempts >= maxAttempts {
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
    private func checkPersistentState() {
        let defaults = UserDefaults.standard
        self.incorrectAttempts = defaults.integer(forKey: attemptsKey)
        
        if let lockoutEndDate = defaults.object(forKey: lockoutKey) as? Date {
            if Date() < lockoutEndDate {
                startCooldown(endDate: lockoutEndDate)
            } else {
                resetLockout()
            }
        }
    }

    private func startCooldown(endDate: Date) {
        self.isLocked = true
        
        cooldownTimer?.invalidate()

        cooldownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let remaining = Int(endDate.timeIntervalSince(Date()))
            
            if remaining > 0 {
                self.remainingCooldown = remaining
            } else {
                self.resetLockout()
            }
        }
        cooldownTimer?.fire()
    }

    func resetLockout() {
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        isLocked = false
        incorrectAttempts = 0
        errorMessage = nil
        pin = ""
        
        UserDefaults.standard.removeObject(forKey: attemptsKey)
        UserDefaults.standard.removeObject(forKey: lockoutKey)
    }
    
    var cooldownMessage: String {
        let minutes = remainingCooldown / 60
        let seconds = remainingCooldown % 60
        return String(format: "Coba lagi dalam %02d:%02d", minutes, seconds)
    }
}

//
//  KeychainService.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import Foundation

class KeychainService {
    static let shared = KeychainService()
    private let pinKey = "user_pin_key" // Nama key sebaiknya tidak pakai spasi

    private init() {}

    // FIX 1: Nama fungsi diubah menjadi savePin (p kecil) sesuai konvensi Swift.
    func savePin(_ pin: String) {
        UserDefaults.standard.set(pin, forKey: pinKey)
        print("PIN saved (simulation).")
    }

    // FIX 2: Nama diubah menjadi retrievePin & return type menjadi String? (opsional).
    // Ini menghilangkan kebutuhan 'throws' dan 'try!' yang berbahaya.
    func retrievePin() -> String? {
        return UserDefaults.standard.string(forKey: pinKey)
    }

    // FIX 3: Nama fungsi diubah menjadi deletePin (p kecil).
    func deletePin() {
        UserDefaults.standard.removeObject(forKey: pinKey)
        print("PIN deleted (simulation).")
    }
}

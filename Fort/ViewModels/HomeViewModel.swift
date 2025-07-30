//  HomeViewModel.swift
//  Fort
//
//  Created by Dicky Dharma Susanto on 24/07/25.
//

// ViewModels/HomeViewModel.swift

// ViewModels/HomeViewModel.swift

import Foundation
import SwiftUI

enum LoanLimitStatus {
    case notRegistered
    case calculating
    case limitAvailable
    case upcomingPayment
}

class HomeViewModel: ObservableObject {
    @Published var loanLimitStatus: LoanLimitStatus
    @Published var isNavigatingToLogin = false
    @Published var isNavigatingToApplyLoan = false
    
    @Published var amount = 67_700
    var dueDate: Date {
        Calendar.current.date(byAdding: .day, value: 20, to: Date()) ?? Date()
    }
    
    var daysRemainingText: String {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 0
        if days > 0 {
            return "Tersisa \(days) hari"
        } else if days == 0 {
            return "Jatuh tempo hari ini"
        } else {
            return "Sudah jatuh tempo"
        }
    }
    
    init(initialStatus: LoanLimitStatus = .notRegistered) {
        self.loanLimitStatus = initialStatus
        
        // ### PERUBAHAN DI SINI ###
        // Jika status awal adalah 'calculating', mulai timer 5 detik.
        if initialStatus == .calculating {
            startCalculationTimer()
        }
    }
    
    private func startCalculationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // Ganti status ke .limitAvailable setelah 5 detik
            // Pastikan statusnya masih .calculating untuk menghindari race condition
            if self.loanLimitStatus == .calculating {
                self.loanLimitStatus = .limitAvailable
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Int {
    func formattedWithSeparator() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

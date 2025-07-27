//
//  CalculatorViewModel.swift
//  Fort
//
//  Created by Dicky Dharma Susanto on 23/07/25.
//

import Foundation
import SwiftUI

enum LoanDuration: Int, CaseIterable, Identifiable {
    case threeMonths = 3
    case sixMonths = 6
    case twelveMonths = 12

    var id: Int { rawValue }

    var displayText: String {
        switch self {
        case .threeMonths: return "3 Bulan"
        case .sixMonths: return "6 Bulan"
        case .twelveMonths: return "12 Bulan"
        }
    }
}

enum LoanRecommendation: String {
    case allowed
    case notRecommended
    case caution

    var message: String {
        switch self {
        case .allowed:
            return "Pinjaman ini sesuai dengan kemampuan finansialmu. Kamu bisa melanjutkan pengajuan dengan aman karena cicilan tidak membebani pendapatanmu."
        case .notRecommended:
            return "Kami tidak menyarankan pinjaman ini karena cicilan melebihi sisa pendapatanmu setelah pengeluaran. Risiko gagal bayar cukup tinggi."
        case .caution:
            return "Hati-hati! Jumlah cicilan mendekati batas kemampuan finansialmu. Pertimbangkan kembali sebelum melanjutkan pengajuan."
        }
    }

    var color: Color {
        switch self {
        case .allowed: return .green
        case .notRecommended: return .red
        case .caution: return .orange
        }
    }
}

class CalculatorViewModel: ObservableObject {

    @Published var income: Double = 2_000_000
    @Published var expenses: Double = 2_000_000
    @Published var loanAmount: Double = 2_000_000
    @Published var loanDuration: LoanDuration = .threeMonths
    @Published var isNavigatingToCalculator = false
    @Published var isNavigatingToHome = false
    @Published var minPrice: Double = 100_000
    @Published var maxPrice: Double = 10_000_0000
    
    private func formatInput(_ input: String) -> String {
        let cleaned = input.replacingOccurrences(of: ".", with: "").filter { $0.isNumber }
        guard let number = Int(cleaned) else { return "" }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }

    private func parseCurrencyString(_ input: String) -> Double {
        let cleaned = input.replacingOccurrences(of: ".", with: "")
        return Double(cleaned) ?? 0
    }
    
    var monthlyInstallment: Double {
        return loanAmount / Double(loanDuration.rawValue)
    }

    var recommendation: LoanRecommendation {
        if income <= expenses {
            return .notRecommended
        } else if monthlyInstallment > (income - expenses) {
            return .caution
        } else {
            return .allowed
        }
    }

    var pieChartData: [PieChartItem] {
        let total = income + expenses + loanAmount
        return [
            PieChartItem(value: income / total, label: "Pendapatan", color: .green),
            PieChartItem(value: expenses / total, label: "Pengeluaran", color: .yellow),
            PieChartItem(value: loanAmount / total, label: "Pinjaman", color: .black)
        ]
    }
}

struct PieChartItem: Identifiable {
    let id = UUID()
    let value: Double
    let label: String
    let color: Color
}

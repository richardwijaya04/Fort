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
            return "Berdasarkan data anda, pengajuan pinjaman dapat dilakukan."
        case .notRecommended:
            return "Tidak disarankan meminjam karena pengeluaran melebihi pendapatan."
        case .caution:
            return "Hati-hati, kemampuan membayar bulanan anda mendekati batas."
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
    @Published var minPrice: Double = 100000
    @Published var maxPrice: Double = 100000000
    
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

import Foundation

// Enum untuk tenor yang lebih aman dan jelas daripada menggunakan Integer biasa.
enum LoanTenor: Int, CaseIterable, Identifiable {
    case threeMonths = 3
    case sixMonths = 6
    case twelveMonths = 12

    var id: Int { self.rawValue }

    var displayText: String {
        return "\(self.rawValue) Bulan"
    }
}

// Model untuk merepresentasikan detail satu cicilan.
struct Installment: Identifiable {
    let id = UUID()
    let period: Int
    let dueDate: Date
    let principal: Double // Cicilan Pokok
    let interest: Double  // Bunga
    let tax: Double       // PPN

    var total: Double {
        principal + interest + tax
    }
}

// Model untuk rekening bank.
struct BankAccount: Identifiable, Hashable {
    let id: String
    let bankName: String
    let accountNumber: String
    let accountHolderName: String
    let logoName: String
}

//
//  ApplyLoanViewModal.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 25/07/25.
//

import Foundation
import Combine

@MainActor
class ApplyLoanViewModel: ObservableObject {

    // MARK: - Input Properties
    @Published var loanAmount: Double = 160_000 {
        didSet {
            // Memicu kalkulasi ulang saat slider digeser
            loanAmountSubject.send(loanAmount)
        }
    }
    @Published var selectedTenor: LoanTenor = .threeMonths {
        didSet {
            // Langsung kalkulasi ulang saat tenor diganti
            recalculateDetails()
        }
    }
    @Published var selectedBankAccount: BankAccount?
    @Published var hasAgreedToTerms: Bool = false
    @Published var hasNoOtherLoans: Bool = false
    
    // MARK: - Output Properties (Data untuk ditampilkan di View)
    @Published private(set) var minLoan: Double = 100_000
    @Published private(set) var maxLoan: Double = 2_000_000
    @Published private(set) var dailyInterestRate: Double = 0.003 // 0.3%
    @Published private(set) var taxRate: Double = 0.11 // PPN 11%
    @Published private(set) var amountReceived: Double = 0
    @Published private(set) var monthlyInterest: Double = 0
    @Published private(set) var totalRepayment: Double = 0
    @Published private(set) var installmentSchedule: [Installment] = []
    @Published private(set) var availableBankAccounts: [BankAccount] = []
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    // Subject untuk debounce input dari slider agar tidak kalkulasi terus-menerus
    private let loanAmountSubject = PassthroughSubject<Double, Never>()

    // MARK: - Computed Properties
    var isSubmissionEnabled: Bool {
        hasAgreedToTerms && hasNoOtherLoans && selectedBankAccount != nil
    }

    // Formatter untuk kemudahan di View
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp "
        formatter.groupingSeparator = "."
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: - Initializer
    init() {
        // Simulasi pengambilan data awal
        fetchInitialData()
        
        // Atur pipeline Combine untuk menangani input slider
        loanAmountSubject
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main) // Menunggu 250ms setelah user berhenti menggeser
            .sink { [weak self] _ in
                self?.recalculateDetails()
            }
            .store(in: &cancellables)
        
        // Kalkulasi pertama saat view model dibuat
        recalculateDetails()
    }

    // MARK: - Public Methods
    func submitLoanApplication() {
        guard isSubmissionEnabled else { return }
        print("Pengajuan pinjaman sedang diproses...")
        print("Jumlah: \(loanAmount), Tenor: \(selectedTenor.displayText), Rekening: \(selectedBankAccount?.bankName ?? "-")")
        // Di sini Anda akan memanggil service/API untuk mengirim data
    }
    
    // MARK: - Private Logic
    private func fetchInitialData() {
        // Ini adalah data dummy, pada aplikasi nyata ini akan diambil dari API
        self.availableBankAccounts = [
            .init(id: "BCA-1", bankName: "Bank Central Asia", accountNumber: "123XXXXX456", accountHolderName: "Budi", logoName: "bca_logo"),
            .init(id: "BNI-1", bankName: "Bank Negara Indonesia", accountNumber: "789XXXXX012", accountHolderName: "Budi", logoName: "bni_logo"),
            .init(id: "MDR-1", bankName: "Bank Mandiri", accountNumber: "456XXXXX789", accountHolderName: "Budi", logoName: "mandiri_logo")
        ]
        self.selectedBankAccount = availableBankAccounts.first
    }

    private func recalculateDetails() {
        let principal = self.loanAmount
        let tenorInMonths = Double(self.selectedTenor.rawValue)
        
        // Jumlah Diterima
        self.amountReceived = principal
        
        // Bunga per bulan
        // (Suku Bunga Harian * Jumlah Hari dalam sebulan (rata-rata 30) * Pokok Pinjaman)
        self.monthlyInterest = dailyInterestRate * 30 * principal
        
        // Total Pembayaran
        let totalInterest = self.monthlyInterest * tenorInMonths
        self.totalRepayment = principal + totalInterest
        
        // Jadwal Cicilan
        var schedule: [Installment] = []
        let principalPerMonth = principal / tenorInMonths
        
        for i in 1...self.selectedTenor.rawValue {
            let interestForThisMonth = principalPerMonth * dailyInterestRate * 30
            let taxForThisMonth = interestForThisMonth * taxRate
            
            let installment = Installment(
                period: i,
                dueDate: Calendar.current.date(byAdding: .month, value: i, to: Date()) ?? Date(),
                principal: principalPerMonth,
                interest: interestForThisMonth,
                tax: taxForThisMonth
            )
            schedule.append(installment)
        }
        self.installmentSchedule = schedule
        
        // Re-calculate total repayment based on schedule to be more precise
        self.totalRepayment = schedule.reduce(0) { $0 + $1.total }
    }
}

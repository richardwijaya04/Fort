//
//  ApplyLoanView.swift
//  Fort
//
//  Created by Dicky Dharma Susanto on 24/07/25.
//

import SwiftUI

// MARK: - Main View
struct ApplyLoanView: View {
    @StateObject private var viewModel = ApplyLoanViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // Latar belakang abu-abu untuk seluruh layar
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Setiap bagian adalah kartu putih terpisah
                    loanAmountCard
                    tenorCard
                    loanDetailsCard
                    
                    termsAndConditionsSection
                        .padding(.horizontal)
                    
                    Spacer(minLength: 24)
                    
                    submitButton
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Pinjaman")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
    }

    // MARK: - Card Components
    private var loanAmountCard: some View {
        VStack(spacing: 8) {
            Text("Jumlah Pinjaman")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.loanAmount)) ?? "Rp 0")
                .font(.system(size: 40, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            customSliderView
            
            HStack {
                Text(viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.minLoan)) ?? "Rp 0")
                Spacer()
                Text(viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.maxLoan)) ?? "Rp 0")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var tenorCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tenor Pinjaman")
                .font(.headline)

            HStack(spacing: 12) {
                ForEach(LoanTenor.allCases) { tenor in
                    tenorButton(tenor: tenor)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var loanDetailsCard: some View {
        // Menggunakan Vstack biasa, bukan dari ViewModel
        VStack(alignment: .leading, spacing: 16) {
            detailRow(label: "Jumlah Diterima", value: viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.amountReceived)) ?? "-")
            detailRow(label: "Suku Bunga per Hari", value: String(format: "%.2f%%", viewModel.dailyInterestRate * 100))
            detailRow(label: "Bunga per Bulan", value: viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.monthlyInterest)) ?? "-")

            // ## PERBAIKAN DROPDOWN DI SINI ##
            // Style baru diterapkan, yang membungkus semuanya dalam satu kartu putih.
            DisclosureGroup(
                "Jadwal Cicilan",
                content: {
                    VStack(spacing: 16) {
                        ForEach(viewModel.installmentSchedule) { installment in
                            installmentDetailView(installment: installment)
                        }
                    }
                    .padding()
                }
            )
            .disclosureGroupStyle(IntegratedWhiteCardStyle())
            
            DisclosureGroup(
                content: {
                    VStack(alignment: .leading) {
                         ForEach(viewModel.availableBankAccounts) { account in
                             bankAccountRow(account: account)
                         }
                    }
                    .padding()
                },
                label: {
                    HStack {
                        Text("Rekening Pencairan")
                        Spacer()
                        Text(viewModel.selectedBankAccount?.accountNumber ?? "Pilih Rekening")
                    }
                }
            )
            .disclosureGroupStyle(IntegratedWhiteCardStyle())
            
            Divider()

            HStack {
                Text("Total Pembayaran")
                    .fontWeight(.bold)
                Spacer()
                Text(viewModel.currencyFormatter.string(from: NSNumber(value: viewModel.totalRepayment)) ?? "-")
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    // ## PERBAIKAN ALIGNMENT CHECKBOX DI SINI ##
    private var termsAndConditionsSection: some View {
        HStack(alignment: .top, spacing: 10) {
            // Kolom khusus untuk ikon Checkbox
            VStack(alignment: .center, spacing: 16) {
                Toggle("", isOn: $viewModel.hasAgreedToTerms)
                    .toggleStyle(CheckboxOnlyStyle())
                    // Menyesuaikan tinggi agar cocok dengan baris teks pertama
                    .frame(height: 30, alignment: .top)

                Toggle("", isOn: $viewModel.hasNoOtherLoans)
                    .toggleStyle(CheckboxOnlyStyle())
                    // Menyesuaikan tinggi agar cocok dengan baris teks pertama
                    .frame(height: 30, alignment: .top)
            }
            
            // Kolom khusus untuk Teks
            VStack(alignment: .leading, spacing: 16) {
                Text("Sebelum melanjutkan, saya telah membaca dan memahami **Perjanjian Pinjaman**")
                    .font(.caption)
                    .frame(height: 30, alignment: .leading)

                Text("Saya telah membaca dan menyetujui pernyataan **Tidak Memiliki Pendanaan di 3 Platform Pinjaman atau Lebih**")
                    .font(.caption)
                    .frame(height: 30, alignment: .leading)
            }
        }
    }
    
    // MARK: - Helper Views & Functions (Tidak ada perubahan di bawah ini)
    
    private var submitButton: some View {
        Button(action: viewModel.submitLoanApplication) {
            Text("Ajukan Pinjaman")
                .fontWeight(.bold)
                .foregroundColor(viewModel.isSubmissionEnabled ? .black : Color(.systemGray))
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isSubmissionEnabled ? Color("Primary") : Color(.systemGray4))
                .cornerRadius(12)
        }
        .disabled(!viewModel.isSubmissionEnabled)
    }
    
    private var customSliderView: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color(.systemGray5))
                .frame(height: 8)
            
            Slider(value: $viewModel.loanAmount, in: viewModel.minLoan...viewModel.maxLoan, step: 10_000)
                 // Ganti warna thumb/kenop menjadi putih
                .accentColor(.white)
                // Jadikan track transparan agar track custom di belakang terlihat
                .onAppear {
                    UISlider.appearance().minimumTrackTintColor = UIColor(Color("Primary").opacity(0.8))
                    UISlider.appearance().maximumTrackTintColor = .clear
                    UISlider.appearance().thumbTintColor = .white
                }
        }
    }

    @ViewBuilder
    private func tenorButton(tenor: LoanTenor) -> some View {
        Button(action: { viewModel.selectedTenor = tenor }) {
            Text(tenor.displayText)
                .font(.subheadline).fontWeight(.bold)
                .foregroundColor(viewModel.selectedTenor == tenor ? .black : .secondary)
                .padding(.vertical, 10).frame(maxWidth: .infinity)
                .background(viewModel.selectedTenor == tenor ? Color("Primary") : Color(.systemGray5))
                .cornerRadius(8)
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            Text(value).font(.subheadline).fontWeight(.semibold)
        }
    }
    
    private func navigationRow(label: String, value: String? = nil) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            if let value = value { Text(value).font(.subheadline).fontWeight(.semibold) }
            Image(systemName: "chevron.right").foregroundColor(.secondary)
        }
    }

    private func installmentDetailView(installment: Installment) -> some View {
         VStack(alignment: .leading, spacing: 8) {
             HStack {
                 Text("Periode \(installment.period): \(installment.dueDate, formatter: Date.shortDate)")
                     .fontWeight(.bold).foregroundColor(.primary)
                 Spacer()
                 Text(viewModel.currencyFormatter.string(from: NSNumber(value: installment.total)) ?? "-")
                     .fontWeight(.bold).foregroundColor(.primary)
             }
             detailRow(label: "Pokok Pinjaman", value: viewModel.currencyFormatter.string(from: NSNumber(value: installment.principal)) ?? "-")
             detailRow(label: "Bunga Pinjaman", value: viewModel.currencyFormatter.string(from: NSNumber(value: installment.interest)) ?? "-")
             detailRow(label: "PPN", value: viewModel.currencyFormatter.string(from: NSNumber(value: installment.tax)) ?? "-")
         }
         .font(.caption)
    }
    
    private func bankAccountRow(account: BankAccount) -> some View {
        Button(action: {
            viewModel.selectedBankAccount = account
        }) {
            HStack {
                Image(account.logoName)
                    .resizable().scaledToFit().frame(height: 25)
                    .background(Color.white).clipShape(Circle())
                Text(account.bankName).foregroundColor(.primary)
                Spacer()
                if viewModel.selectedBankAccount == account {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color("Primary"))
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Custom Styles & Extensions

/// ## STYLE DROPDOWN BARU ##
/// Style ini membuat seluruh DisclosureGroup (label + content) menjadi satu kartu putih.
struct IntegratedWhiteCardStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    configuration.isExpanded.toggle()
                }
            }) {
                HStack {
                    configuration.label
                        .font(.subheadline)
                        .foregroundColor(configuration.isExpanded ? .primary : .secondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(configuration.isExpanded ? 90 : 0))
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            if configuration.isExpanded {
                Divider()
                configuration.content
            }
        }
        .background(Color(.systemGray6)) // Warna latar belakang untuk konten
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

/// ## STYLE CHECKBOX BARU ##
/// Style ini hanya menggambar ikon kotak, untuk alignment yang presisi.
struct CheckboxOnlyStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(configuration.isOn ? Color("Primary") : .gray)
        }
        .buttonStyle(.plain)
    }
}

extension Date {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}

// MARK: - Preview
#Preview {
    NavigationView {
        ApplyLoanView()
    }
}

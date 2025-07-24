//
//  CalculatorSimulator.swift
//  Fort
//
//  Created by Dicky Dharma Susanto on 23/07/25.
//

import SwiftUI

struct CalculatorSimulatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Simulasi Keuangan")
                    .font(.title)
                    .bold()

                // Income
                VStack(alignment: .leading) {
                    Text("Jumlah Pendapatan: Rp \(Int(viewModel.income), format: .number)")
                        .fontWeight(.semibold)
                    Slider(value: $viewModel.income, in: viewModel.minPrice...viewModel.maxPrice, step: 100_000)
                        .tint(.green)
                    HStack {
                        Text("Rp \(Int(viewModel.minPrice), format: .number)")
                        Spacer()
                        Text("Rp \(Int(viewModel.maxPrice), format: .number)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }

                // Expenses
                VStack(alignment: .leading) {
                    Text("Jumlah Pengeluaran: Rp \(Int(viewModel.expenses), format: .number)")
                        .fontWeight(.semibold)
                    Slider(value: $viewModel.expenses, in: viewModel.minPrice...viewModel.maxPrice, step: 100_000)
                        .tint(.green)
                    HStack {
                        Text("Rp \(Int(viewModel.minPrice), format: .number)")
                        Spacer()
                        Text("Rp \(Int(viewModel.maxPrice), format: .number)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }

                // Loan Amount
                VStack(alignment: .leading) {
                    Text("Jumlah Pinjaman: Rp \(Int(viewModel.loanAmount), format: .number)")
                        .fontWeight(.semibold)
                    Slider(value: $viewModel.loanAmount, in: viewModel.minPrice...viewModel.maxPrice, step: 100_000)
                        .tint(.green)
                    HStack {
                        Text("Rp \(Int(viewModel.minPrice), format: .number)")
                        Spacer()
                        Text("Rp \(Int(viewModel.maxPrice), format: .number)")
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                }

                // Duration Picker
                VStack(alignment: .leading) {
                    Text("Jangka Waktu Pinjaman: \(viewModel.loanDuration.displayText)")
                        .fontWeight(.semibold)
                    Picker("Durasi", selection: $viewModel.loanDuration) {
                        ForEach(LoanDuration.allCases) { duration in
                            Text(duration.displayText).tag(duration)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                // Result Section
                VStack(spacing: 12) {
                    Text("Rekomendasi Pinjaman")
                        .font(.headline)
                    Text("Rp \(Int(viewModel.loanAmount), format: .number)")
                        .font(.title2)
                        .bold()

                    Text("Cicilan Per Bulan")
                        .font(.subheadline)
                    Text("Rp \(Int(viewModel.monthlyInstallment), format: .number)")
                        .font(.title3)
                        .bold()

                    PieChartView(data: viewModel.pieChartData)
                        .frame(width: 180, height: 180)

                    Text(viewModel.recommendation.message)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(viewModel.recommendation.color)
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)

                // Call to Action
                Button("Daftar Akun Sekarang") {
                    // Aksi daftar
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.7, green: 0.9, blue: 0.3))
                .foregroundColor(.black)
                .cornerRadius(12)
            }
            .padding()
        }
    }
}


#Preview {
    CalculatorSimulatorView()
}

struct PieChartView: View {
    let data: [PieChartItem]

    var body: some View {
        GeometryReader { geo in
            let radius = min(geo.size.width, geo.size.height) / 2
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let total = data.reduce(0) { $0 + $1.value }

            ZStack {
                ForEach(Array(data.enumerated()), id: \.1.id) { index, item in
                    let startAngle = Angle(degrees: 360 * data.prefix(index).reduce(0) { $0 + $1.value } / total)
                    let endAngle = Angle(degrees: 360 * data.prefix(index + 1).reduce(0) { $0 + $1.value } / total)

                    PieSlice(startAngle: startAngle, endAngle: endAngle)
                        .fill(item.color)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        var path = Path()
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}


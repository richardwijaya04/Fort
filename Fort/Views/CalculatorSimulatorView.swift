import SwiftUI

struct CalculatorSimulatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        ZStack (alignment: .top) {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        viewModel.isNavigatingToHome = true
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    
                    Spacer()
                    
                    Text("Simulasi Keuangan")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                }
                .padding(.bottom, 20)
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Jumlah Pendapatan")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Jumlah Pendapatan", value: $viewModel.income, format: .number)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Jumlah Pengeluaran")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Jumlah Pengeluaran", value: $viewModel.expenses, format: .number)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Jumlah Pinjaman")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                TextField("Jumlah Pinjaman", value: $viewModel.loanAmount, format: .number)
                                    .textFieldStyle(CustomTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tenor Pinjaman")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 12) {
                                    ForEach(LoanDuration.allCases) { duration in
                                        Button(action: {
                                            viewModel.loanDuration = duration
                                        }) {
                                            Text(duration.displayText)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(viewModel.loanDuration == duration ? .black : .gray)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(viewModel.loanDuration == duration ?
                                                              Color(red: 0.8, green: 0.9, blue: 0.4) :
                                                                Color.gray.opacity(0.1))
                                                )
                                        }
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        
                        VStack(spacing: 0) {
                            VStack(spacing: 8) {
                                Text("Pinjaman Ideal")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                                
                                Text("Rp \(formatCurrency(viewModel.loanAmount))")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Text("Cicilan Per Bulan")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                
                                Text("Rp \(formatCurrency(viewModel.monthlyInstallment))")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 24)
                            .padding(.bottom, 20)
                            
                            PieChartView(data: viewModel.pieChartData)
                                .frame(width: 120, height: 120)
                                .padding(.bottom, 16)
                            
                            Text(viewModel.recommendation.message)
                                .font(.system(size: 12))
                                .foregroundColor(viewModel.recommendation.color)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                            
                            Button {
                                
                            } label: {
                                Text("Daftar Akun Sekarang")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.8, green: 0.9, blue: 0.4))
                                    )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(red: 0.9, green: 0.95, blue: 0.7))
                        )
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 20)
                .background(
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .ignoresSafeArea(.all, edges: .bottom)
                        .shadow(radius: 8)
                )
            }
            
        }
        .navigationBarHidden(true)
        NavigationLink(
            destination: HomeView(),
            isActive: $viewModel.isNavigatingToHome
        ) {
            EmptyView()
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: amount)) ?? "0"
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.9, green: 0.95, blue: 0.7))
            )
            .font(.system(size: 14))
    }
}

struct PieChartView: View {
    let data: [PieChartItem]
    
    var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                PieSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: item.color
                )
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let totalValue = data.reduce(0) { $0 + $1.value }
        let previousValues = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (previousValues / totalValue) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let totalValue = data.reduce(0) { $0 + $1.value }
        let valuesUpToIndex = data.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: (valuesUpToIndex / totalValue) * 360 - 90)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        Path { path in
            let center = CGPoint(x: 60, y: 60)
            let radius: CGFloat = 60
            
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            path.closeSubpath()
        }
        .fill(color)
    }
}

#Preview {
    CalculatorSimulatorView()
}

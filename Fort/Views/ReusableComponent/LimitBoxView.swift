//
//  LimitBoxView.swift
//  FortHome
//
//  Created by Elia K on 22/07/25.
//

import SwiftUI

struct LimitBoxView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .shadow(radius: 5)
            
            VStack(alignment: .center, spacing: 16) {
                Text("Limit Pinjaman Anda")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom,4)
                Text("Rp. 2.000.000")
                    .foregroundColor(Color(hex: "ECFDCF"))
                    .font(.system(size: 44))
                    .fontWeight(.bold)
                
                // Button below the HStack
                Button {
                    homeViewModel.isNavigatingToApplyLoan = true
                } label: {
                    Text("Ajukan Pinjaman")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.79, green: 0.95, blue: 0.35)) // Light green
                        .cornerRadius(12)
                }
            }
            .padding()
            NavigationLink(
                destination: ApplyLoanView(),
                isActive: $homeViewModel.isNavigatingToApplyLoan
            ) {
                EmptyView()
            }
        }
        .frame(width:356, height: 220)
    }
}

struct UpcomingBillCardView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Tagihan Terdekat")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                VStack {
                    HStack {
                        Text("Jumlah Pembayaran")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text("Rp \(homeViewModel.amount.formattedWithSeparator())")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Jatuh Tempo")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                        Text(homeViewModel.dueDate.formatted(date: .numeric, time: .omitted))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                
                Text("\(homeViewModel.daysRemainingText) ")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "C4E860"))
                    .padding(.top, 4)
                
                Button {
                    // Tambahkan action bayar
                } label: {
                    Text("Bayar Sekarang")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(hex: "C4E860"))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .frame(width: 356, height: 220)
    }
}

#Preview {
    UpcomingBillCardView()
        .environmentObject(HomeViewModel())
}


#Preview {
    LimitBoxView().environmentObject(HomeViewModel())
}

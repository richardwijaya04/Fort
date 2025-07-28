//  ContentView.swift
//  FortHome
//
//  Created by Elia K on 21/07/25.
//

// Views/HomeView.swift

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var otpModel: OTPViewModel
    @StateObject var homeViewModel: HomeViewModel // Deklarasi diubah
    
    // Initializer baru yang mengizinkan status awal untuk di-passing
    init(initialStatus: LoanLimitStatus = .notRegistered) {
        _homeViewModel = StateObject(wrappedValue: HomeViewModel(initialStatus: initialStatus))
    }
    
    var body: some View {
        ScrollView {
            ZStack{
                VStack{
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .ignoresSafeArea(edges: .top)
                        .padding(.top, -20)
                    Spacer()
                }
                VStack (spacing: 10) {
                    Logo_HelpCentreView()
                        .padding(.bottom, 30)
                    
//                    HStack {
//                        // Tombol-tombol ini bisa dihapus jika hanya untuk debugging
//                        Button("Belum Daftar") { homeViewModel.loanLimitStatus = .notRegistered }
//                        Button("Menghitung") { homeViewModel.loanLimitStatus = .calculating }
//                        Button("Limit Siap") { homeViewModel.loanLimitStatus = .limitAvailable }
//                        Button("Upcoming") { homeViewModel.loanLimitStatus = .upcomingPayment }
//                    }
//                    .padding()
                    
                    switch homeViewModel.loanLimitStatus {
                    case .notRegistered:
                        RegisterBoxView()
                            .frame(width: 356, height: 220)
                            .padding(.bottom, 20)
                        
                    case .calculating:
                        LimitLoadView()
                            .frame(width: 356, height: 220)
                            .padding(.bottom, 20)
                        
                    case .limitAvailable:
                        LimitBoxView()
                            .frame(width: 356, height: 220)
                            .padding(.bottom, 20)
                            
                    case .upcomingPayment:
                        UpcomingBillCardView()
                            .frame(width: 356, height: 220)
                            .padding(.bottom, 20)
                    }
                    
                    FinPlannerView()
                    
                    VStack (alignment: .leading, spacing: 8){
                        Text("Edukasi Keuangan")
                            .font(.system(size: 24, weight: .semibold))
                        CarouselCard()
                            .frame(height: 258)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true) // Sembunyikan navigation bar bawaan
        .environmentObject(homeViewModel)
    }
}

#Preview {
    // Preview sekarang juga bisa dites dengan status berbeda
    HomeView(initialStatus: .upcomingPayment)
        .environmentObject(OTPViewModel())
}

struct Logo_HelpCentreView: View {
    var body: some View {
        HStack(spacing: 100){
            Text("LOGO")
                .font(.system(size: 28, weight: .bold, design: .default))
            Button(action: {}) {
                
                HStack {
                    Image(systemName: "headset")
                        .padding(.leading,15)
                        .padding(.top,8)
                        .padding(.bottom,8)
                    Text("Pusat Bantuan")
                        .padding(.trailing,15)
                        .padding(.top,8)
                        .padding(.bottom,8)
                    
                    
                }
                .foregroundColor(Color(hex: "C4E860"))
                .background(Color(hex: "181E1E"))
                .fontWeight(.semibold)
                .cornerRadius(110)
                
            }
            
        }
        .padding()
    }
}

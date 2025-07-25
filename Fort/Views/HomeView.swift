//
//  ContentView.swift
//  FortHome
//
//  Created by Elia K on 21/07/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var otpModel: OTPViewModel
    @StateObject var calculatorModel: CalculatorViewModel = CalculatorViewModel()
    @StateObject var homeViewModel = HomeViewModel()
    
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
                    
                    HStack {
                        Button {
                            homeViewModel.loanLimitStatus = .notRegistered
                        } label: {
                            Text("Belum Daftar")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundStyle(.white)
                        }
                        Button {
                            homeViewModel.loanLimitStatus = .calculating
                        } label: {
                            Text("Menghitung")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundStyle(.white)
                        }
                        Button {
                            homeViewModel.loanLimitStatus = .limitAvailable
                        } label: {
                            Text("Limit Siap")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundStyle(.white)
                        }
                        Button {
                            homeViewModel.loanLimitStatus = .upcomingPayment
                        } label: {
                            Text("Upcoming Limit")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding()
                    
                    switch homeViewModel.loanLimitStatus {
                    case .notRegistered:
                        RegisterBoxView()
                            .frame(width: 356, height: 200)
                            .padding(.bottom, 20)
                        
                    case .calculating:
                        LimitLoadView()
                            .frame(width: 356, height: 200)
                            .padding(.bottom, 20)
                        
                    case .limitAvailable:
                        LimitBoxView()
                            .frame(width: 356, height: 200)
                            .padding(.bottom, 20)
                    case .upcomingPayment:
                        UpcomingBillCardView()
                            .frame(width: 356, height: 200)
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
        .navigationBarBackButtonHidden()
        .environmentObject(homeViewModel)
    }
}

#Preview {
    NavigationStack{
        HomeView().environmentObject(OTPViewModel())
    }
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


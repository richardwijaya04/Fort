//
//  HomeView.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 18/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var otpModel: OTPViewModel
    
    var body: some View{
        VStack(spacing: 20) {
            Text("Home")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Anda berhasil login!")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button("Logout") {
                otpModel.logout()
            }
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.red)
        }
        .padding()
        .navigationTitle("Home")
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
        .environmentObject(OTPViewModel())
}

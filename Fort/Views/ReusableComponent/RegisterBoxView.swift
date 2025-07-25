//
//  RegisterBoxView.swift
//  FortHome
//
//  Created by Elia K on 21/07/25.
//

import SwiftUI

struct RegisterBoxView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Belum Punya Akun?")
                    .font(.system(size: 22))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom,-24)
                HStack(alignment: .center) {
                    
                    
                    Text("Daftar sekarang dan temukan jumlah pinjaman yang sesuai dengan kondisi keuanganmu.")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .lineSpacing(6)
                    
                    
                    
                    // Right-side image placeholder
                    Image("person-data") // Replace with actual illustration asset
                    //                                .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                    
                }
                
                // Button below the HStack
                Button {
                    homeViewModel.isNavigatingToLogin = true
                } label: {
                    Text("Daftar Akun Pinjaman")
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
                destination: LoginView()
                    .environmentObject(OTPViewModel()),
                isActive: $homeViewModel.isNavigatingToLogin
            ) {
               EmptyView()
            }.hidden()
        }
        .frame(height: 220)
        
    }
}

#Preview {
    RegisterBoxView().environmentObject(HomeViewModel())
}

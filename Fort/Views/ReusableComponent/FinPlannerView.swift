//
//  FinPlannerView.swift
//  FortHome
//
//  Created by Elia K on 22/07/25.
//

import SwiftUI

struct FinPlannerView: View {
    
    @StateObject var calculatorViewModel: CalculatorViewModel = CalculatorViewModel()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Belum Yakin dengan Kondisi Keuanganmu?")
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Coba simulasi dulu untuk mengetahui batas pinjaman ideal sebelum daftar.")
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Spacer()
                    Button {
                        calculatorViewModel.isNavigatingToCalculator = true
                    } label: {
                        Text("Coba Simulasi")
                            .foregroundColor(Color(hex: "181E1E"))
                            .padding()
                            .frame(width: 116, height: 32)
                            .background(Color(hex: "C4E860"))
                            .cornerRadius(8)
                            .font(.system(size: 12, weight: .bold))
                            .kerning(-0.2)
                    }
                }
                .padding(.top, 16)
            }
            .padding(16)
        }
        .frame(width: 356, height: 200)
        
        NavigationLink(
            destination: CalculatorSimulatorView().environmentObject(calculatorViewModel),
            isActive: $calculatorViewModel.isNavigatingToCalculator
        ) {
            EmptyView()
        }
    }
}


#Preview {
    NavigationStack{
        FinPlannerView()
    }
}

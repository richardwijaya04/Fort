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
        ZStack{
            Rectangle()
                .fill(Color.white)
                .cornerRadius(8)
            VStack{
                VStack {
                    Text("Sudah Tahu Batas Pinajaman Idealmu?")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.trailing,24)
                        .padding(.bottom,4)
                    Text("Coba simulasi untuk tahu berapa batas pinjaman yang \naman dan sesuai kemampuan finansialmu")
                        .font(.system(size: 10, weight: .regular))
                        .padding(.trailing,48)
                        
                }
                
                    
                    
                HStack{
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
                    .padding(.top,24)
                }
            }
            .padding()
            
        }
        .frame(width: 356, height: 156)
        .shadow(radius: 10)
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

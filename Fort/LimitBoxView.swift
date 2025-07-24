//
//  LimitBoxView.swift
//  FortHome
//
//  Created by Elia K on 22/07/25.
//

import SwiftUI

struct LimitBoxView: View {
    var body: some View {
        ZStack {
                    // Background card
                    RoundedRectangle(cornerRadius: 20)
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
                        Button(action: {
                            // Handle button tap
                        }) {
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
                }
                .frame(height: 220)
                .padding()
    }
}

#Preview {
    LimitBoxView()
}

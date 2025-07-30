//
//  PINInputView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//


import SwiftUI

struct PINInputView: View {
    let pin: String
    let pinLength: Int
    let hasError: Bool

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<pinLength, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        // MENGGUNAKAN WARNA YANG SAMA DENGAN OTP VIEW
                        .fill(Color("Secondary").opacity(0.5))
                        .frame(width: 50, height: 55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(hasError ? Color.red : Color.clear, lineWidth: 1.5)
                        )
                    
                    if index < pin.count {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 15, height: 15)
                            .transition(.scale)
                    }
                }
            }
        }
        .animation(.spring(), value: pin)
        .animation(.default, value: hasError)
    }
}

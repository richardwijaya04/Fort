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

    // Warna hijau muda yang lebih sesuai dengan desain referensi
    private let boxColor = Color(red: 233/255, green: 245/255, blue: 236/255)

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<pinLength, id: \.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(boxColor)
                        .frame(width: 50, height: 55)
                        .overlay(
                            // Border hanya muncul (merah) saat ada error
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

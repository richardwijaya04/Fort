//
//  PINInputView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI
import SwiftUI

struct PINInputView: View {
    let pin: String
    let pinLength: Int
    let hasError: Bool

    // Warna hijau muda yang sesuai dengan desain
    private let boxColor = Color(red: 239/255, green: 243/255, blue: 244/255)
    private let filledBoxColor = Color(red: 216/255, green: 238/255, blue: 225/255)


    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<pinLength, id: \.self) { index in
                ZStack {
                    let isFilled = index < pin.count
                    
                    RoundedRectangle(cornerRadius: 12)
                        // Gunakan warna hijau jika terisi, jika tidak warna abu-abu muda
                        .fill(isFilled ? filledBoxColor : boxColor)
                        .frame(height: 55)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(hasError ? Color.red : Color.clear, lineWidth: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

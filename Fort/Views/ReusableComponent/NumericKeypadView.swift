//
//  NumericKeypadView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import SwiftUI

struct NumericKeypadView: View {
    // Aksi yang akan di-trigger ke ViewModel
    var onDigitTapped: (String) -> Void
    var onDeleteTapped: () -> Void
    var onSpecialKeyTapped: () -> Void // Untuk tombol +*#

    // State untuk menyimpan urutan angka yang sudah diacak
    @State private var shuffledDigits: [[String]] = []

    // Teks sub-header untuk setiap tombol angka
    private let digitSubheadings = [
        "1": " ", "2": "ABC", "3": "DEF",
        "4": "GHI", "5": "JKL", "6": "MNO",
        "7": "PQRS", "8": "TUV", "9": "WXYZ"
    ]

    var body: some View {
        VStack(spacing: 12) {
            // Menampilkan 3 baris angka yang sudah diacak
            ForEach(shuffledDigits, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { digit in
                        KeypadButton(
                            digit: digit,
                            subheading: digitSubheadings[digit] ?? "",
                            action: { onDigitTapped(digit) }
                        )
                    }
                }
            }

            // Baris keempat yang statis (tidak diacak)
            HStack(spacing: 12) {
                // Tombol +*#
                KeypadButton(digit: "+ * #", action: onSpecialKeyTapped)

                // Tombol 0
                KeypadButton(digit: "0", action: { onDigitTapped("0") })

                // Tombol Hapus (Backspace)
                Button(action: onDeleteTapped) {
                    KeypadButtonContent(
                        content: AnyView(Image(systemName: "delete.left"))
                    )
                }
            }
        }
        .padding(.horizontal)
        .onAppear(perform: shuffleKeys) // Acak tombol saat view muncul
    }
    
    // Fungsi untuk mengacak angka 1-9
    private func shuffleKeys() {
        let numbers = (1...9).map { String($0) }.shuffled()
        // Membagi array 1D [1...9] menjadi array 2D [[...], [...], [...]]
        self.shuffledDigits = [
            Array(numbers[0...2]),
            Array(numbers[3...5]),
            Array(numbers[6...8])
        ]
    }
}

// Subview untuk konten tombol (agar bisa dipakai untuk Angka & Ikon)
struct KeypadButtonContent: View {
    let content: AnyView
    
    var body: some View {
        content
            .font(.largeTitle)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .foregroundColor(.primary)
    }
}


// Subview untuk tombol keypad (menghindari duplikasi kode)
struct KeypadButton: View {
    let digit: String
    var subheading: String? = nil
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if let subheading = subheading, !subheading.trimmingCharacters(in: .whitespaces).isEmpty {
                // Tombol dengan angka dan teks sub-header
                KeypadButtonContent(
                    content: AnyView(
                        VStack(spacing: -2) {
                            Text(digit)
                            Text(subheading)
                                .font(.system(size: 10))
                                .offset(y: -4)
                        }
                    )
                )
            } else {
                // Tombol biasa (untuk 0, +*#, dll)
                KeypadButtonContent(
                    content: AnyView(Text(digit))
                )
            }
        }
    }
}

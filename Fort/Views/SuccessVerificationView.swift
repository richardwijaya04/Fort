//
//  SuccessVerificationView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 24/07/25.
//

import SwiftUI

struct SuccessVerificationView: View {
    var body: some View {
        ZStack {
            // Light green background
            Color(red: 0.94, green: 0.96, blue: 0.88)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                // Green circle with checkmark
                ZStack {
                    Circle()
                        .fill(Color(red: 0.7, green: 0.85, blue: 0.4))
                        .frame(width: 120, height: 120)

                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(spacing: 12) {
                    // Title
                    Text("Akun Berhasil Dibuat")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    // Subtitle
                    Text(
                        "Verifikasi berhasil, identitas anda\ntelah terkonfirmasi"
                    )
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                }

                Spacer()
            }
//            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    SuccessVerificationView()
}

//
//  FailedVerificationView.swift
//  Fort
//
//  Created by Lin Dan Christiano on 24/07/25.
//

import SwiftUI

struct FailedVerificationView: View {
    let onRetry: () -> Void
    var body: some View {
        ZStack {
            Color("FailedVerificationBackground")
                .ignoresSafeArea()
            Spacer()
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color("FailedVerificationPrimary"))
                        .frame(width: 120, height: 120)
                    Image(systemName: "xmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                Text("Verifikasi Gagal")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Tidak dapat mengenali wajah anda Pastikan wajah terlihat jelas dan berada dalam bingkai")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                Button(action: {
                    // Action to retry verification
                    onRetry()
                }) {
                    Text("Coba Lagi")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: 250)
                        .foregroundStyle(.black)
                        .padding()
                        .background(Color("FailedVerificationPrimary"))
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
    }
}
//
//#Preview {
//    FailedVerificationView()
//}

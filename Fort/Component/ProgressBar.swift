//
//  ProgressBar.swift
//  Fort
//
//  Created by Lin Dan Christiano on 22/07/25.
//

import SwiftUI

struct ProgressBar: View {
    var stepsNum: Int
    @Binding var currentStep: Int
    let stepTitle: [String] = ["KTP", "Data Diri", "Pekerjaan", "Bank", "Kontak", "Verifikasi Wajah"]
    var body: some View {
        HStack(spacing: 0){
            ForEach(0 ..< stepsNum, id:\.self) { item in
                ZStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color("BulletBar"))
                    if item <= currentStep {
                        Circle()
                            .fill(.black)
                    }
                }
                .frame(width: 15, height: 15)
                    .overlay(content: {
                            Text(stepTitle[item])
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 45, height: 20)
                            .font(.system(size: 8, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .offset(x: 0, y: 20)
                            .foregroundStyle(item <= currentStep ? .black : .gray)
                    })
                if item < stepsNum - 1 {
                    ZStack {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(Color("Primary"))
                        Rectangle()
                            .frame(height: 3)
                            .frame(maxWidth: item >= currentStep ? 0 : .infinity, alignment: .leading)
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }
}

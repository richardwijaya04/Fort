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
    var body: some View {
        HStack(spacing: 0){
            ForEach(0 ..< stepsNum, id:\.self) { item in
                Circle().stroke(lineWidth: item <= currentStep ? 10 : 2)
                    .frame(width: 15, height: item <= currentStep ? 3 : 15)
                    .foregroundStyle(item <= currentStep ? .black : Color("BulletBar"))
                    .background(Color("BulletBar"))
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
    }
}

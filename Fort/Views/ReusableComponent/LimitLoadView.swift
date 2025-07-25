//
//  LimitLoadView.swift
//  FortHome
//
//  Created by Elia K on 22/07/25.
//

import SwiftUI

struct LimitLoadView: View {
    @State private var progress = 0.27
    
    var body: some View {
        
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black)
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Menghitung Limit Kreditmu...")
                    .font(.system(size: 28))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom,48)
                
                
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // The background of the progress bar.
                        // A Capsule shape gives perfectly rounded ends.
                        Capsule()
                            .frame(height: 16) // Set the thickness of the bar
                            .foregroundColor(Color.white.opacity(1))
                        
                        // The foreground (progress) of the bar.
                        Capsule()
                        // The width is calculated based on the progress value.
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "C1E55F"), Color(hex: "181E1E")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geometry.size.width * progress, height: 10)
                        
                    }
                }
                // We must constrain the GeometryReader's height, otherwise it expands infinitely.
                .frame(height: 16)
            }
            .padding()
        }
        .frame(width:356, height: 220)
        .padding()
    }
}

#Preview {
    LimitLoadView()
}

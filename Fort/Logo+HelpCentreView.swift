//
//  Logo+HelpCentreView.swift
//  FortHome
//
//  Created by Elia K on 22/07/25.
//

import SwiftUI

struct Logo_HelpCentreView: View {
    var body: some View {
        HStack(spacing: 100){
            Text("LOGO")
                .font(.system(size: 28, weight: .bold, design: .default))
//            Spacer()
            Button(action: {}) {
                
                HStack {
                    Image(systemName: "headset")
                        .padding(.leading,15)
                        .padding(.top,8)
                        .padding(.bottom,8)
                    Text("Pusat Bantuan")
                        .padding(.trailing,15)
                        .padding(.top,8)
                        .padding(.bottom,8)
                        
                    
                }
                .foregroundColor(Color(hex: "C4E860"))
                .background(Color(hex: "181E1E"))
                .fontWeight(.semibold)
                .cornerRadius(110)
                
            }
          
        }
        .padding()
    }
}

#Preview {
    Logo_HelpCentreView()
}

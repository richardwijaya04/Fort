//
//  PrimaryButton.swift
//  Fort
//
//  Created by William on 22/07/25.
//

import SwiftUI

struct PrimaryButton: View {
    
    var text : String
    
    var onClick : (() -> Void)?
    
    
    var body: some View {
        Button {
           onClick?()
        } label: {
            Text(text)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .bold()
                .background(RoundedRectangle(cornerRadius:  10).fill(Color("Primary")))
        }
    }
}

#Preview {
    PrimaryButton(text: "Testing") {
        
    }
}

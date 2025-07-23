//
//  ErrorButton.swift
//  Fort
//
//  Created by William on 23/07/25.
//

import SwiftUI

struct ErrorButton: View {
    
    var text : String
    
    var onClick : (() -> Void)?
    
    
    var body: some View {
        Button {
           onClick?()
        } label: {
            Text(text)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .bold()
                .background(RoundedRectangle(cornerRadius:  10).fill(.red))
        }
    }
}

#Preview {
    ErrorButton(text: "Testing") {
        
    }
}

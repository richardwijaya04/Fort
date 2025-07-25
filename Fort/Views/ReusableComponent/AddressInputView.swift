//
//  AddressInputView.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

struct AddressInputView: View {
    @Binding var text: String
    var title : String
    var placeholder : String?
    @Binding var state : formState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .bold))

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder ?? title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray.opacity(0.5))
                        .italic()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .padding([.leading, .top], 1)
                }

                TextEditor(text: $text)
                    .submitLabel(.done)
                    .padding(10)
                    
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color("Secondary")) // light green
            .overlay(
                       RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: state.isError ? 1 : 0)
                   )
            .cornerRadius(10)
            .foregroundColor(.black)
            .scrollContentBackground(.hidden) // 💡 this is crucial!
            
            if state.isError {
                Text(state.message)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    AddressInputView(text: .constant(""), title: "Halo", state: .constant(.emptyField(msg: "test")))
}

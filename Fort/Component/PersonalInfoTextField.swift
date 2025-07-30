//
//  PersonalInfoTextField.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

struct PersonalInfoTextField: View {
    @Binding var text : String
    var title : String
    var placeholder: String? // if nil, placeholder = title
    var isDisabled : Bool = false
    var keyboardType : UIKeyboardType = .default
    @Binding var state : formState
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
            
            HStack {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder ?? title)
                        .font(.system(size: 12, weight: .medium))
                        .italic()
                )
                .keyboardType(keyboardType)
                .submitLabel(.done)
                .disabled(isDisabled)
                .padding(.vertical, 10)

            }
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("Secondary"))
                    .overlay(
                               RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: state.isError ? 1 : 0)
                           )
            )
            
            if state.isError {
                Text(state.message)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    PersonalInfoTextField(text: .constant(""), title: "Halo", placeholder: "Test", state: .constant(.emptyField(msg: "test")))
}

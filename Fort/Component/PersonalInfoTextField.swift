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
                .submitLabel(.continue)
                .disabled(isDisabled)
                .padding(.vertical, 10)

            }
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("Secondary"))
            )

        }
    }
}

#Preview {
    PersonalInfoTextField(text: .constant(""), title: "Halo", placeholder: "Test")
}

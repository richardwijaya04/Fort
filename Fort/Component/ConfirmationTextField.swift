//
//  ConfirmationTextField.swift
//  Fort
//
//  Created by William on 22/07/25.
//

import SwiftUI

struct ConfirmationTextField: View {
    
    @Binding var text : String
    var title : String
    var placeholder: String?
    var icon : String = "pencil.line"
    var isDisabled : Bool = false
    var keyboardType : UIKeyboardType = .default
    var onSuffixButtonClicked : (() -> Void)?

    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
            
            HStack {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder ?? title)
                        .font(.system(size: 11, weight: .medium))
                )
                .keyboardType(keyboardType)
                .submitLabel(.continue)
                .disabled(isDisabled)
                .padding(.vertical, 10)

                Button(action: {
                    onSuffixButtonClicked?()
                }) {
                    Image(systemName: icon) // Use SF Symbol or Text
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("Secondary"))
            )

        }
    }
}

#Preview {
//    ConfirmationTextField(text: .constant(""), placeholder: "Placeholder")
    OCRView()
}

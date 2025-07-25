//
//  PersonalInfoDropDown.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

struct PersonalInfoDropDown: View {
    var title: String
    var hint: String?
    var options: [String]
    @Binding var selection: String
    var isEditable: Bool = true
    @Binding var state : formState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .bold))

            if isEditable {
                Menu {
                    Picker(selection: Binding(
                        get: { selection ?? "" },
                        set: { selection = $0 }
                    )) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    } label: {
                        EmptyView()
                    }
                } label: {
                    HStack {
                        Text(selection.isEmpty ? (hint ?? title) : selection)
                            .font(.system(size: 12, weight: .medium))
                            .italic(selection.isEmpty)
                            .foregroundColor(selection.isEmpty ? Color.gray.opacity(0.6) : .primary)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "chevron.down.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.black)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Secondary"))
                            .overlay(
                                       RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red, lineWidth: state.isError ? 1 : 0)
                                   )
                    )
                }
            } else {
                HStack {
                    Text(selection ?? (hint ?? title))
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.6))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.gray.opacity(0.3))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Secondary"))
                        

                )
            }
            
            if state.isError {
                Text(state.message)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.red)
            }
        }
    }
}

struct PersonalInfoDropDown_Previews: PreviewProvider {
    @State var selectedOption: String = ""
    
    static var previews: some View {
        return Group {
            PersonalInfoDropDown(
                title: "Pendidikan",
                hint: "Pilih pendidikan",
                options: ["SMA", "D3", "S1", "S2", "S3"],
                selection: .constant("SMA"), state: .constant(.emptyField(msg: "TEst"))
            )
            .previewDisplayName("Editable Dropdown")

        }
        .previewLayout(.sizeThatFits)
    }
}

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
    @Binding var selection: String?
    var isEditable: Bool = true
    
    @State private var showPicker: Bool = false
    @State private var tempSelection: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
            
            Button(action: {
                if isEditable {
                    // Preload selection
                    tempSelection = selection ?? options.first ?? ""
                    showPicker = true
                }
            }) {
                HStack {
                    Text(selection ?? (hint ?? title))
                        .font(.system(size: 14))
                        .foregroundColor(selection == nil ? Color.gray.opacity(0.6) : .primary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if isEditable {
                        Image(systemName: "chevron.down.square.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.black)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("Secondary"))
                )
            }
            .disabled(!isEditable)
        }
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                VStack {
                    Picker("", selection: $tempSelection) {
                        ForEach(options, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(.wheel)
                    .labelsHidden()
                }
                .navigationTitle("Pilih \(title)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Selesai") {
                            selection = tempSelection
                            showPicker = false
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Batal") {
                            showPicker = false
                        }
                    }
                }
            }
            .presentationDetents([.height(300)])
        }
    }
}



#Preview {
    PersonalInfoDropDown(title: "test", hint: "test1", options: ["test1", "test2", "test3"], selection: .constant("test1"))
}


//
//  ContactInputBlock.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 23/07/25.
//

import SwiftUI

/// Component View untuk satu blok form input kontak.
struct ContactInputBlock: View {
    let title: String
    @Binding var contact: EmergencyContact // Menggunakan binding ke model langsung
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            // Dropdown Hubungan
            Menu {
                 Picker("Hubungan", selection: $contact.relationship) {
                    Text("Pilih Hubungan").tag("") // Opsi default
                    ForEach(options, id: \.self) {
                        Text($0).tag($0)
                    }
                }
            } label: {
                HStack {
                    Text(contact.relationship.isEmpty ? "Hubungan" : contact.relationship)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .cornerRadius(8)
                .foregroundColor(contact.relationship.isEmpty ? Color.gray.opacity(0.6) : .primary)
            }
            
            // TextField Nama
            TextField("Nama", text: $contact.name)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .cornerRadius(8)

            // TextField Nomor Telepon
            TextField("Nomor Telepon", text: $contact.phone)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.lime.opacity(0.15))
        .cornerRadius(16)
    }
}

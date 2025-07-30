//
//  EmergencyContactView.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 23/07/25.
//

import SwiftUI

struct ContactInfoView: View {
    
    @StateObject private var viewModel = ContactInfoViewModel()
    let onNext: () -> Void
    
    init(onNext: @escaping () -> Void) {
        self.onNext = onNext
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
//                    ProgressHeaderView(currentStep: .kontak)
                    
                    Text("Data ini diperlukan untuk proses verifikasi dan keamanan tambahan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Membuat form secara dinamis dari data di ViewModel
                    ForEach($viewModel.contacts) { $contact in
                        let index = viewModel.contacts.firstIndex(where: { $0.id == contact.id }) ?? 0
                        ContactInputBlock(
                            title: "Info Kontak \(index + 1)",
                            contact: $contact,
                            options: viewModel.relationshipOptions
                        )
                    }

                    Button {
                        viewModel.submitContacts()
                        onNext()
                    }
                    label : {
                        Text("Selanjutnya")
                            .fontWeight(.semibold)
                            .foregroundColor(viewModel.isFormValid ? .black : .gray.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? Color.lime : Color.lime.opacity(0.5))
                            .cornerRadius(12)
                    }
                    .padding(.top, 16)
                    .disabled(!viewModel.isFormValid) // Tombol disable jika form tidak valid
                    
                }
                .padding()
            }
            .navigationTitle(Text("Kontak"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        // Aksi untuk tombol kembali
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.black)
//                    }
//                }
//            }
            .background(Color.white)
        }
    }
}

//#Preview {
//    ContactInfoView()
//}

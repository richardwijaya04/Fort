//
//  ContactInfoViewModel.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 23/07/25.
//

import Foundation

@MainActor
class ContactInfoViewModel: ObservableObject {
    
    /// Array yang menampung data untuk kedua kontak darurat.
    /// Menggunakan array dari model membuat kode lebih rapi dan scalable.
    @Published var contacts: [EmergencyContact] = [EmergencyContact(), EmergencyContact()]
    
    /// Opsi yang akan ditampilkan di dropdown hubungan.
    let relationshipOptions = ["Orang Tua", "Saudara Kandung", "Pasangan", "Teman"]
    
    /// Computed property untuk mengecek apakah semua field sudah terisi.
    /// Ini akan digunakan untuk mengaktifkan/menonaktifkan tombol "Selanjutnya".
    var isFormValid: Bool {
        // `allSatisfy` akan return true hanya jika semua kontak dalam array
        // memenuhi kondisi yang diberikan (tidak ada field yang kosong).
        contacts.allSatisfy { contact in
            !contact.relationship.isEmpty &&
            !contact.name.isEmpty &&
            !contact.phone.isEmpty
        }
    }
    
    /// Fungsi yang akan dipanggil saat tombol "Selanjutnya" ditekan.
    func submitContacts() {
        guard isFormValid else {
            print("❌ Form belum lengkap.")
            return
        }
        
        print("✅ Data kontak berhasil disubmit!")
        for (index, contact) in contacts.enumerated() {
            print("""
            --- Kontak \(index + 1) ---
            Hubungan: \(contact.relationship)
            Nama: \(contact.name)
            Nomor: \(contact.phone)
            """)
        }
        
        // Di sini Anda bisa menambahkan logika untuk menyimpan data
        // atau navigasi ke halaman berikutnya.
    }
}

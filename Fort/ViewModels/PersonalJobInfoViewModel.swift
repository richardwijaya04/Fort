//
//  PersonalJobInfoViewModel.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

final class PersonalJobInfoViewModel: ObservableObject {
    @Published var pendapatanBulanan: String = ""
    @Published var pendapatanBulananState : formState = .none
    
    @Published var tanggalPenerimaanGaji : String = ""
    @Published var tanggalPenerimaanGajiState : formState = .none
    
    @Published var namaPerusahaan : String = ""
    @Published var namaPerusahaanState : formState = .none
    
    @Published var lamaBekerja : String = ""
    @Published var lamaBekerjaState : formState = .none
    static let listLamaBekerja : [String] = ["< 1 tahun", "1 - 5 tahun", "> 5 tahun"]
    
    @Published var alamatPerusahaan : String = ""
    @Published var alamatPerusahaanState : formState = .none
    
    @Published var provinsiPerusahaan : String = ""
    @Published var provinsiPerusahaanState : formState = .none
    static let listProvinsiPerusahaan : [String] = [
        "DKI Jakarta"
    ]
    
    @Published var kecamatannyaPerusahaan : String = ""
    @Published var kecamatannyaPerusahaanState : formState = .none
    static let listKecamatanPerusahaan : [String] = [
        "Kebayoran Baru",
        "Tebet",
        "Cempaka Putih",
        "Gambir",
        "Kramat Jati",
        "Penjaringan"
    ]
    
    @Published var kelurahanPerusahaan : String = ""
    @Published var kelurahanPerusahaanState : formState = .none
    static let listKelurahanPerusahaan : [String] = [
        "Senayan",
        "Manggarai",
        "Rawasari",
        "Cideng",
        "Cililitan",
        "Pluit"
    ]
    
    @Published var noTelpPerusahaan : String = ""
    @Published var noTelpPerusahaanState : formState = .none
    
    @Published var isUserValid : Bool = false
    
    func validateForm() {
        var validTillEnd = true
        let msg = "harus di isi"
        
        if namaPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self .namaPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if pendapatanBulanan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.pendapatanBulananState = .emptyField(msg: msg)
                
            }
        }
        
        if tanggalPenerimaanGaji.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.tanggalPenerimaanGajiState = .emptyField(msg: msg)
            }
        }
        else if let date = Int(tanggalPenerimaanGaji), date > 31 {
            validTillEnd = false
            DispatchQueue.main.async {
                self.tanggalPenerimaanGajiState = .emptyField(msg: "tanggal tidak valid")
            }
        }
        
        if lamaBekerja.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.lamaBekerjaState = .emptyField(msg: msg)
            }
        }
        
        if alamatPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.alamatPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if provinsiPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.provinsiPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if kecamatannyaPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.kecamatannyaPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if kelurahanPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.kelurahanPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if noTelpPerusahaan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.noTelpPerusahaanState = .emptyField(msg: msg)
            }
        }
        
        if validTillEnd {
            DispatchQueue.main.async {
                self.isUserValid = true
            }
        }
    }
}

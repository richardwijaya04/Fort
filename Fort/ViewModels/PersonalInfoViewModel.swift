//
//  PersonalInfoViewModel.swift
//  Fort
//
//  Created by William on 23/07/25.
//

import Foundation

enum formState {
    case none
    case valid
    case emptyField(msg : String)
    
    var message : String {
        switch self {
        case .emptyField(msg: let msg):
            return msg
        case .valid:
            return ""
        case .none:
            return ""
        }
    }
    
    var isError : Bool {
        switch self {
        case .none, .valid:
            return false
        default :
            return true
        }
    }
}

class PersonalInfoViewModel : ObservableObject {
    let ocrResult : OCRResult
    
    @Published var tujuanPenggunaanDana : String = ""
    @Published var tujuanPenggunaanDanaState : formState = .none
    
    @Published var statusPendidikan : String = ""
    @Published var statusPendidikanState : formState = .none
    static let listStatusPendidikan : [String] = [
        "Tidak Sekolah", "Sekolah Rendah", "Sekolah Menengah Atas", "Sekolah Tinggi", "Pelajar/Mahasiswa", "S1", "S2", "S3"]
    
    
    @Published var statusPernikahan : String = ""
    @Published var statusPernikahanState : formState = .none
    static let listStatusPernikahan : [String] = ["Belum Menikah", "Sudah Menikah", "Cerai"]
    
    @Published var provinsiTempatTinggal : String = ""
    @Published var provinsiTempatTinggalState : formState = .none
    static let listProvinsiTempatTinggal: [String] = [
        "DKI Jakarta"
    ]
    
    @Published var kotaTempatTinggal : String = ""
    @Published var kotaTempatTinggalState : formState = .none
    static let listKotaTempatTinggal: [String] = [
        "Jakarta Pusat",
        "Jakarta Utara",
        "Jakarta Selatan",
        "Jakarta Barat",
        "Jakarta Timur"
    ]
    
    @Published var kelurahanTempatTinggal : String = ""
    @Published var kelurahanTempatTinggalState : formState = .none
    static let listKelurahanTempatTinggal: [String] = [
        "Gambir",
        "Menteng",
        "Cempaka Putih",
        "Kebayoran Baru",
        "Tebet"
    ]
    
    @Published var alamatTempatTinggal : String = ""
    @Published var alamatTempatTinggalState : formState = .none
    @Published var isUserValid : Bool = false
    
    init(ocrResult: OCRResult) {
        self.ocrResult = ocrResult
        onInitialize()
    }
    
    func validateForm() -> Bool {
        var validTillEnd = true
        let msg = "Harus di isi"
        
        // biar state kereset kalo di validate ulang
//        tujuanPenggunaanDanaState = .none
//        statusPendidikanState = .none
//        statusPernikahanState = .none
//        alamatTempatTinggalState = .none
//        provinsiTempatTinggalState = .none
//        kotaTempatTinggalState = .none
//        kelurahanTempatTinggalState = .none
        
        if tujuanPenggunaanDana.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.tujuanPenggunaanDanaState = .emptyField(msg: msg)
            }
        }
        
        if statusPendidikan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.statusPendidikanState = .emptyField(msg: msg)
            }
        }
        
        if statusPernikahan.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.statusPernikahanState = .emptyField(msg: msg)
            }
        }
        
        if alamatTempatTinggal.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.alamatTempatTinggalState = .emptyField(msg: msg)
            }
        }
        
        if provinsiTempatTinggal.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.provinsiTempatTinggalState = .emptyField(msg: msg)
            }
        }
        
        if kotaTempatTinggal.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.kotaTempatTinggalState = .emptyField(msg: msg)
            }
        }
        
        if kelurahanTempatTinggal.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.kelurahanTempatTinggalState = .emptyField(msg: msg)
            }
        }
        
//        if validTillEnd {
//            isUserValid = true
//        }
        return validTillEnd
    }
}

private extension PersonalInfoViewModel {
    func onInitialize() {
        print(ocrResult.printSummary())
        DispatchQueue.main.async {
            self.statusPernikahan = self.ocrResult.statusPerkawinan ?? ""
            self.kelurahanTempatTinggal = self.ocrResult.kelurahan ?? ""
            self.alamatTempatTinggal = self.ocrResult.address ?? ""
            
        }
    }
}

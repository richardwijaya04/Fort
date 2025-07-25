//
//  BankInfoViewModel.swift
//  Fort
//
//  Created by William on 25/07/25.
//

import Foundation

final class BankInfoViewModel : ObservableObject {
    
    @Published var namaPemilikBank : String = ""
    @Published var namaPemilikBankState : formState = .none
    
    @Published var namaBank : String = ""
    @Published var namaBankState : formState = .none
    static var listNamaBank : [String] = ["BCA", "BNI", "Mandiri", "BRI", "CIMB NIAGA", "CIMB CLIENT", "CIMB ANGGOTA", "PERMIA", "HSBC", "UOB"]
    
    @Published var nomorRekening : String = ""
    @Published var nomorRekeningState : formState = .none
    
    @Published var isUserValid : Bool = false
    func validateForm() {
        var validTillEnd = true
        let msg = "harus di isi"
        
        if namaPemilikBank.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.namaPemilikBankState = .emptyField(msg: msg)
            }
        }
        
        if namaBank.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.namaBankState = .emptyField(msg: msg)
            }
        }
        
        if nomorRekening.isEmpty {
            validTillEnd = false
            DispatchQueue.main.async {
                self.nomorRekeningState = .emptyField(msg: msg)
            }
        }
        
        
        if validTillEnd {
            DispatchQueue.main.async {
                self.isUserValid = true
            }
        }
    }
}

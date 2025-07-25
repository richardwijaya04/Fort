//
//  PersonalInfoView.swift
//  Fort
//
//  Created by William on 23/07/25.
//

import SwiftUI

struct PersonalInfoView: View {
    
    let ocrResult : OCRResult
    @StateObject var viewModel : PersonalInfoViewModel
    
    init(ocrResult: OCRResult) {
        self.ocrResult = ocrResult
        _viewModel = StateObject(wrappedValue: PersonalInfoViewModel(ocrResult: ocrResult))
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing: 15) {
                PersonalInfoTextField(text: .constant(""), title: "Email", placeholder: "Email Pribadi")
                PersonalInfoTextField(text: .constant(""), title: "Tujuan Penggunaan Dana")
                PersonalInfoDropDown(title: "Status Pendidikan", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                PersonalInfoDropDown(title: "Status Pernikahan", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                PersonalInfoDropDown(title: "Provinsi Tempat Tinggal", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                PersonalInfoDropDown(title: "Kota Tempat Tinggal", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                PersonalInfoDropDown(title: "Kelurahan Tempat Tinggal", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                PersonalInfoDropDown(title: "Alamat Tempat Tinggal", options: ["S1","S2","S3","S4","S5"], selection: .constant("S1"))
                
                PersonalInfoTextField(text: .constant(""), title: "Alamat Tempat Tinggal")
                
                Text("Kesalahan data dapat menyebabkan proses verifikasi Anda ditolak")
                    .font(.system(size: 10, weight: .regular))
                    .padding(.bottom,14)
                
                PrimaryButton(text: "Selanjutnya") {
                    
                }
                 
                
                //TODO: Tambahin image diawasi olehnya
            }
            .padding(.all, 25)
            .navigationTitle(Text("Data Diri"))
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    PersonalInfoView(ocrResult: OCRResult())
}

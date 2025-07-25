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
    @StateObject var keyboardObserver : KeyboardObserver = KeyboardObserver()
    
    init(ocrResult: OCRResult) {
        self.ocrResult = ocrResult
        _viewModel = StateObject(wrappedValue: PersonalInfoViewModel(ocrResult: ocrResult))
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PersonalJobInfoView(), isActive: $viewModel.isUserValid) {
                EmptyView()
            }
            .hidden()
            ScrollView {
                VStack (spacing: 50) {
                    VStack (spacing: 15) {
                        PersonalInfoTextField(text: $viewModel.tujuanPenggunaanDana,title: "Tujuan Penggunaan Dana", state: $viewModel.tujuanPenggunaanDanaState)
                        
                        PersonalInfoDropDown(title: "Pendidikan", options: PersonalInfoViewModel.listStatusPendidikan, selection: $viewModel.statusPendidikan, state: $viewModel.statusPendidikanState)
                        
                        PersonalInfoDropDown(title: "Status Pernikahan", options: PersonalInfoViewModel.listStatusPernikahan, selection: $viewModel.statusPernikahan, state: $viewModel.statusPernikahanState)
                        
                    }
                    
                    VStack (spacing: 15) {
                        AddressInputView(text: $viewModel.alamatTempatTinggal, title: "Alamat Tempat Tinggal", state: $viewModel.alamatTempatTinggalState)
                        
                        PersonalInfoDropDown(title: "Provinsi Tempat Tinggal", options: PersonalInfoViewModel.listProvinsiTempatTinggal, selection: $viewModel.provinsiTempatTinggal, state: $viewModel.provinsiTempatTinggalState)
                        
                        PersonalInfoDropDown(title: "Kota Tempat Tinggal", options: PersonalInfoViewModel.listKotaTempatTinggal, selection: $viewModel.kotaTempatTinggal, state: $viewModel.kotaTempatTinggalState)
                        
                        PersonalInfoDropDown(title: "Kelurahan Tempat Tinggal", options: PersonalInfoViewModel.listKelurahanTempatTinggal, selection: $viewModel.kelurahanTempatTinggal, state: $viewModel.kelurahanTempatTinggalState)
                        
                        Text("Kesalahan data dapat menyebabkan proses verifikasi Anda ditolak")
                            .font(.system(size: 10, weight: .regular))
                            .padding(.bottom,14)
                        
                        PrimaryButton(text: "Selanjutnya") {
                            viewModel.validateForm()
                        }
                        
                        LogoOJKAFPIView()
                        
                    }
                }
                .padding(.all, 25)
                .onTapGesture {
                    if keyboardObserver.isKeyboardVisible {
                       hideKeyboard()
                    }
                }
            }
        }
        .navigationTitle(Text("Data Diri"))
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    PersonalInfoView(ocrResult: OCRResult())
}

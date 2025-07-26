//
//  PersonalJobInfoView.swift
//  Fort
//
//  Created by William on 24/07/25.
//

import SwiftUI

struct PersonalJobInfoView: View {
    
    @ObservedObject var viewModel = PersonalJobInfoViewModel()
    @StateObject var keyboardObserver : KeyboardObserver = KeyboardObserver()
    let onNext: () -> Void
    
    init(viewModel: PersonalJobInfoViewModel, onNext: @escaping () -> Void) {
        self.onNext = onNext
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
//            NavigationLink(destination: BankInfoView(),isActive: $viewModel.isUserValid) {
//                EmptyView()
//            }
//            .hidden()
            ScrollView {
                VStack (spacing: 50){
                    
                    VStack (spacing: 15) {
                        PersonalInfoTextField(text: $viewModel.namaPerusahaan, title: "Nama Perusahaan", state: $viewModel.namaPerusahaanState)
                        
                        PersonalInfoTextField(text: $viewModel.pendapatanBulanan, title: "Pendapatan Bulanan", keyboardType: .numberPad ,state: $viewModel.pendapatanBulananState)
                        
                        PersonalInfoTextField(text: $viewModel.tanggalPenerimaanGaji, title: "Tanggal Penerimaan Gaji",
                                              keyboardType: .numberPad , state: $viewModel.tanggalPenerimaanGajiState)
                        
                        
                        
                        PersonalInfoDropDown(title: "Lama Bekerja", options: PersonalJobInfoViewModel.listLamaBekerja, selection: $viewModel.lamaBekerja, state: $viewModel.lamaBekerjaState)
                        
                    }
                    VStack (spacing: 15) {
                        AddressInputView(text: $viewModel.alamatPerusahaan, title: "Alamat Perusahaan", state: $viewModel.alamatPerusahaanState)
                        
                        PersonalInfoDropDown(title: "Provinsi Perusahaan", options: PersonalJobInfoViewModel.listProvinsiPerusahaan, selection: $viewModel.provinsiPerusahaan, state: $viewModel.provinsiPerusahaanState)
                        
                        PersonalInfoDropDown(title: "Kecamatan Perusahaan", options: PersonalJobInfoViewModel.listKecamatanPerusahaan, selection: $viewModel.kecamatannyaPerusahaan, state: $viewModel.kecamatannyaPerusahaanState)
                        
                        PersonalInfoDropDown(title: "Kelurahan Perusahaan", options: PersonalJobInfoViewModel.listKelurahanPerusahaan, selection: $viewModel.kelurahanPerusahaan, state: $viewModel.kelurahanPerusahaanState)
                        
                        PersonalInfoTextField(text: $viewModel.noTelpPerusahaan, title: "No.Telp Perusahaan", placeholder: "Nomor Telepon Perusahaan", keyboardType: .numberPad, state: $viewModel.noTelpPerusahaanState)
                        
                        Text("Kesalahan data dapat menyebabkan proses verifikasi Anda ditolak")
                            .font(.system(size: 10, weight: .regular))
                            .padding(.bottom,14)
                        
                        PrimaryButton(text: "Selanjutnya") {
                            if viewModel.validateForm() {
                                onNext()
                            }
//                            onNext()
                        }
                        
                        LogoOJKAFPIView()
                    }
                    
                }
                .onTapGesture {
                    if keyboardObserver.isKeyboardVisible {
                       hideKeyboard()
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.all, 25)
            .onChange(of: viewModel.tanggalPenerimaanGaji) { oldValue, newValue in
                    if newValue.count > 2 {
                        viewModel.tanggalPenerimaanGaji = oldValue
                    }
                }
            .onChange(of: viewModel.pendapatanBulanan) { oldValue, newValue in
                // Extract digits only
                let numericOnly = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                
                // If empty, reset to ""
                if numericOnly.isEmpty {
                    viewModel.pendapatanBulanan = ""
                    return
                }

                // Convert to number
                guard let number = Int(numericOnly) else {
                    viewModel.pendapatanBulanan = ""
                    return
                }

                // Format as currency
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.groupingSeparator = ","
                formatter.maximumFractionDigits = 0

                if let formatted = formatter.string(from: NSNumber(value: number)) {
                    viewModel.pendapatanBulanan = "Rp." + formatted
                }
            }


        }
        .navigationTitle(Text("Pekerjaan"))
        .navigationBarTitleDisplayMode(.large)
        
    }
}

//#Preview {
//    PersonalJobInfoView()
//}

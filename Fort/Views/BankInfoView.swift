//
//  BankInfoView.swift
//  Fort
//
//  Created by William on 25/07/25.
//

import SwiftUI

struct BankInfoView: View {
    
    @StateObject private var viewModel: BankInfoViewModel = BankInfoViewModel()
    let onNext: () -> Void
    
    init(onNext: @escaping () -> Void) {
        self.onNext = onNext
    }
    
    
    var body: some View {
        VStack {
            ZStack {
                //TODO: Fill this to emergencyContact's view
//                NavigationLink(destination: EmptyView(),isActive: $viewModel.isUserValid) {
//                    EmptyView()
//                }
//                .hidden()
                ScrollView {
                    VStack (spacing: 15) {
                        VStack (alignment: .leading,spacing: 8) {
                            
                            Text("Input Rekening Bank Anda")
                                .font(.system(size: 24, weight: .semibold))
                            
                            Text("Pastikan nama pemilik rekening sesuai dengan nama di KTP agar proses verifikasi dan pencairan dana berjalan lancar")
                                .font(.system(size: 14, weight: .regular))
                                .multilineTextAlignment(.leading)
                        }
                        
                        PersonalInfoTextField(text: $viewModel.namaPemilikBank, title: "Nama Pemilik Rekening", state: $viewModel.namaPemilikBankState)
                        
                        PersonalInfoDropDown(title: "Bank",hint: "Pilih Bank", options: BankInfoViewModel.listNamaBank,selection: $viewModel.namaBank, state: $viewModel.namaBankState)
                        
                        PersonalInfoTextField(text: $viewModel.nomorRekening, title: "Nomor Rekening", state: $viewModel.nomorRekeningState)
                        
                        Spacer()
                        
                        PrimaryButton(text: "Selanjutnya") {
                            if viewModel.validateForm(){
                                onNext()
                            }
//                            onNext()
                        }
                        
                        LogoOJKAFPIView()
                    }
                    .padding(.all, 25)
                }
            }
            .navigationTitle(Text("Bank"))
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

//#Preview {
//    BankInfoView()
//}

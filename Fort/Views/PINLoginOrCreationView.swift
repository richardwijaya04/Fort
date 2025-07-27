////
////  PINLoginOrCreationView.swift
////  Fort
////
////  Created by Dicky Dharma Susanto on 22/07/25.
////
//
//import SwiftUI
//
//struct PINLoginOrCreationView: View {
//    @State private var isPINSet: Bool = KeychainService.shared.retrievePin() != nil
//    
//    var body: some View {
//        if isPINSet {
//            PINLoginView(isPINSet: $isPINSet)
//        } else {
//            PINCreationFlowView(isPINCreationComplete: $isPINSet)
//        }
//    }
//}
//
//#Preview {
//    PINLoginOrCreationView()
//}

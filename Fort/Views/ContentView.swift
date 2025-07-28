//
//  ContentView.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 16/07/25.
//

// ContentView.swift

import SwiftUI

struct ContentView: View {
//    @AppStorage("log_status") var log_status = false
    @StateObject var otpModel = OTPViewModel()
    
    var body: some View {
        NavigationStack {
//            if otpModel.log_status {
                HomeView()
//            }
//            else {
//                LoginView()
//            }
        }
        .environmentObject(otpModel)
    }
}

#Preview {
    ContentView()
}

//
//  OTPViewModel.swift
//  TestOtp
//
//  Created by Dicky Dharma Susanto on 17/07/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

@MainActor
class OTPViewModel: ObservableObject {
    @Published var code: String = "62"
    @Published var number: String = ""
    @Published var termsAccepted = false
    @Published var promotionsAccepted = false
    
    @Published var otpText: String = ""
    @Published var otpFields: [String] = Array(repeating: "", count: 6)
    
    @Published var isLoading: Bool = false
    @Published var verificationCode: String?
    @Published var isNavigatingToVerification = false
    @AppStorage("log_status") var log_status = false
    
    @Published var timeRemaining = 60
    @Published var timer: AnyCancellable?
    
    @Published var showAlert: Bool = false
    @Published var errorMsg: String = ""
    
    func sendOTP() async {
        guard !isLoading else { return }
        isLoading = true
        
        let fullNumber = "+\(code)\(number)"
        
        do {
            let result = try await PhoneAuthProvider.provider().verifyPhoneNumber(
                fullNumber,
                uiDelegate: nil
            )
            
            isLoading = false
            verificationCode = result
            isNavigatingToVerification = true
            startTimer()
        }
        catch {
            handleError(error: error)
        }
    }
    
    func verifyOTP() async {
        let otp = self.otpText
        guard !isLoading, otp.count == 6 else { return }
        
        isLoading = true
        
        guard let verificationCode = verificationCode else {
            handleError(error: NSError(domain: "OTPViewModel", code: 404, userInfo: [NSLocalizedDescriptionKey: "Verification ID tidak ditemukan."]))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationCode,
            verificationCode: otp
        )
        
        do {
            try await Auth.auth().signIn(with: credential)
            isLoading = false
            log_status = true
            timer?.cancel()
        } catch {
            handleError(error: error)
        }
    }
    
    func startTimer() {
        timeRemaining = 60
        otpText = ""
        otpFields = Array(repeating: "", count: 6)
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                }
            }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            log_status = false
        } catch {
            handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        isLoading = false
        errorMsg = error.localizedDescription
        showAlert.toggle()
        print("❌ Error: \(error.localizedDescription)")
        print("❌ Detail Error: \(error as NSError)")
    }
}

//
//  PINViewModel.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 18/07/25.
//

import Foundation
import Combine

class PINViewModel: ObservableObject {
    enum PINFlowState {
        case creating
        case confirming
        case finished
    }
    
    // --- PERUBAHAN DI SINI ---
    @Published var pin: String = "" {
        didSet {
            // Filter untuk memastikan hanya angka yang bisa masuk
            let filtered = pin.filter { "0123456789".contains($0) }
            
            // Hanya update jika ada perubahan untuk menghindari loop tak terbatas
            if pin != filtered {
                pin = filtered
            }
            
            // Batasi panjang PIN langsung di sini
            if pin.count > pinLength {
                pin = String(pin.prefix(pinLength))
            }
        }
    }
    // --- AKHIR PERUBAHAN ---
    
    @Published var flowState: PINFlowState = .creating
    @Published var pinToConfirm: String = ""
    @Published var pinMismatchError: Bool = false
    
    let pinLength = 6
    
    var viewTitle: String {
        switch flowState {
        case .creating, .confirming:
            return "Buat PIN"
        case .finished:
            return ""
        }
    }
    
    var viewSubtitle: String {
        switch flowState {
        case .creating:
            return "Ketik PIN Baru"
        case .confirming:
            return "Ketik Ulang PIN Baru"
        case .finished:
            return ""
        }
    }
    
    func processPinEntry() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            switch self.flowState {
            case .creating:
                self.pinToConfirm = self.pin
                self.flowState = .confirming
                self.pin = ""
            case .confirming:
                self.validateConfirmationPIN()
            case .finished:
                break
            }
        }
    }
    
    private func validateConfirmationPIN() {
        if pin == pinToConfirm {
            KeychainService.shared.savePin(pin)
            pinMismatchError = false
            flowState = .finished
        } else {
            pinMismatchError = true
            pin = ""
        }
    }
    
    func resetFlow() {
        pin = ""
        pinToConfirm = ""
        pinMismatchError = false
        flowState = .creating
    }
}

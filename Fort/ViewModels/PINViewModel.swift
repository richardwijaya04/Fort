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

    @Published var pin: String = ""
    @Published var flowState: PINFlowState = .creating
    @Published var pinToConfirm: String = ""
    @Published var pinMismatchError: Bool = false // Nama variabel dikoreksi

    let pinLength = 6 // Nama variabel dikoreksi

    // Properties for UI
    var viewTitle: String {
        switch flowState {
        case .creating:
            return "Buat PIN" // Disesuaikan ke Bahasa Indonesia
        case .confirming:
            return "Konfirmasi PIN" // Disesuaikan ke Bahasa Indonesia
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

    func appendDigit(_ digit: String) {
        guard pin.count < pinLength else { return }
        pin += digit

        if pin.count == pinLength {
            processPinEntry()
        }
    }

    func deleteDigit() {
        guard !pin.isEmpty else { return }
        pin.removeLast()
        if pinMismatchError {
            pinMismatchError = false
        }
    }

    private func processPinEntry() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            switch self.flowState {
            case .creating:
                self.pinToConfirm = self.pin
                self.flowState = .confirming
                self.pin = "" // Reset input untuk konfirmasi
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
}

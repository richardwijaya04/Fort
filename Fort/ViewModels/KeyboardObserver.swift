//
//  KeyboardObserver.swift
//  Fort
//
//  Created by William on 25/07/25.
//
import Foundation
import SwiftUI

final class KeyboardObserver: ObservableObject {
    @Published var isKeyboardVisible = false
    
    init() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isKeyboardVisible = true
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            self.isKeyboardVisible = false
        }
    }
}

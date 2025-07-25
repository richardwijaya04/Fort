//
//  EmergencyContact.swift
//  Fort
//
//  Created by Richard WIjaya Harianto on 23/07/25.
//

import Foundation

/// Model untuk merepresentasikan satu data kontak darurat.
struct EmergencyContact: Identifiable {
    let id = UUID()
    var relationship: String = ""
    var name: String = ""
    var phone: String = ""
}

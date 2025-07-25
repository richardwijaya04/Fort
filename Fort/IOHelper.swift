//
//  SwiftUIView.swift
//  Fort
//
//  Created by William on 23/07/25.
//

import Foundation

final class IOHelper {
    var instance = IOHelper()
    
    private init() {}
    
    static func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }

}

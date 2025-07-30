//
//  File.swift
//  Fort
//
//  Created by William on 22/07/25.
//

import Foundation

final class OCRResult: Equatable, ObservableObject {
    
    static func == (lhs: OCRResult, rhs: OCRResult) -> Bool {
        return lhs.nik == rhs.nik &&
               lhs.name == rhs.name &&
               lhs.birthPlace == rhs.birthPlace &&
               lhs.birthDate == rhs.birthDate &&
               lhs.gender == rhs.gender &&
               lhs.address == rhs.address &&
               lhs.rtRw == rhs.rtRw &&
               lhs.kelurahan == rhs.kelurahan &&
               lhs.kecamatan == rhs.kecamatan &&
               lhs.pekerjaan == rhs.pekerjaan &&
               lhs.kewarganegaraan == rhs.kewarganegaraan &&
               lhs.statusPerkawinan == rhs.statusPerkawinan
    }
    
    @Published var nik: String?
    @Published var name: String?
    var birthPlace: String?
    @Published var birthDate: Date?
    var gender: String?
    var address: String?
    var rtRw: String?
    var kelurahan: String?
    var kecamatan: String?
    var pekerjaan: String?
    var kewarganegaraan: String?
    var statusPerkawinan: String?

    init(
        nik: String? = nil,
        name: String? = nil,
        birthPlace: String? = nil,
        birthDate: Date? = nil,
        gender: String? = nil,
        address: String? = nil,
        rtRw: String? = nil,
        kelurahan: String? = nil,
        kecamatan: String? = nil,
        pekerjaan: String? = nil,
        kewarganegaraan: String? = nil,
        statusPerkawinan: String? = nil
    ) {
        self.nik = nik
        self.name = name
        self.birthPlace = birthPlace
        self.birthDate = birthDate
        self.gender = gender
        self.address = address
        self.rtRw = rtRw
        self.kelurahan = kelurahan
        self.kecamatan = kecamatan
        self.pekerjaan = pekerjaan
        self.kewarganegaraan = kewarganegaraan
        self.statusPerkawinan = statusPerkawinan
    }

    static func processOCRText(_ texts: [String]) -> (Bool, OCRResult) {
        let result = OCRResult()
        let sanitized = texts.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

        var fallbackName: String?
        
        for (i, line) in sanitized.enumerated() {
            let originalLine = texts[i].trimmingCharacters(in: .whitespacesAndNewlines)

            if result.nik == nil, let nik = extractNIKRegex(from: originalLine) {
                result.nik = nik
                continue
            }

            if result.birthDate == nil,
               let dateStr = extractDate(from: originalLine),
               let date = parseDate(from: dateStr),
               isAge17OrMore(birthDate: date) {
                result.birthDate = date
            }

            if (line.contains("tempat") || line.contains("lahir")) && result.birthPlace == nil {
                if let components = originalLine.components(separatedBy: ":").last?.split(separator: ",", maxSplits: 1).map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) }),
                   components.count == 2 {
                    result.birthPlace = components[0].capitalized
                }
            }

            if line.contains("jenis kelamin"), result.gender == nil {
                let val = extractNextValue(from: texts, currentIndex: i)?.lowercased() ?? ""
                result.gender = val.contains("laki") ? "Laki-laki" : "Perempuan"
            }

            if line.contains("alamat"), result.address == nil {
                result.address = extractNextValue(from: texts, currentIndex: i)?.capitalized
            }

            if line.contains("rt/rw"), result.rtRw == nil {
                result.rtRw = extractNextValue(from: texts, currentIndex: i)
            }

            if (line.contains("kel") || line.contains("desa")), result.kelurahan == nil {
                result.kelurahan = extractNextValue(from: texts, currentIndex: i)?.capitalized
            }

            if line.contains("kecamatan"), result.kecamatan == nil {
                result.kecamatan = extractNextValue(from: texts, currentIndex: i)?.capitalized
            }

            if line.contains("pekerjaan"), result.pekerjaan == nil {
                result.pekerjaan = extractNextValue(from: texts, currentIndex: i)?.capitalized
            }

            if line.contains("kewarganegaraan"), result.kewarganegaraan == nil {
                result.kewarganegaraan = extractNextValue(from: texts, currentIndex: i)?.uppercased()
            }

            if line.contains("status perkawinan"), result.statusPerkawinan == nil {
                result.statusPerkawinan = extractNextValue(from: texts, currentIndex: i)?.capitalized
            }

            if line.contains("nama") && result.name == nil {
                result.name = extractNextValue(from: texts, currentIndex: i)?.capitalized
            } else if result.name == nil && originalLine == originalLine.uppercased() && originalLine.count > 5 && originalLine.rangeOfCharacter(from: .decimalDigits) == nil {
                fallbackName = originalLine
            }
        }

        if result.name == nil {
            result.name = fallbackName?.capitalized
        }

        let isComplete = result.nik != nil && result.name != nil && result.birthDate != nil
        return (isComplete, result)
    }

    private static func extractNextValue(from lines: [String], currentIndex: Int, maxLookahead: Int = 2) -> String? {
        let line = lines[currentIndex]
        if let colonRange = line.range(of: ":") {
            let value = line[colonRange.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
            if !value.isEmpty {
                return value
            }
        }

        for offset in 1...maxLookahead {
            let nextIndex = currentIndex + offset
            if nextIndex < lines.count {
                let next = lines[nextIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                if !next.contains(":") && next.range(of: #"^[a-zA-Z0-9 /.-]+$"#, options: .regularExpression) != nil {
                    return next
                }
            }
        }

        return nil
    }

    private static func extractNIKRegex(from line: String) -> String? {
        if let match = line.range(of: #"\b\d{16}\b"#, options: .regularExpression) {
            return String(line[match])
        }
        return nil
    }

    private static func extractDate(from line: String) -> String? {
        if let match = line.range(of: #"\b\d{2}-\d{2}-\d{4}\b"#, options: .regularExpression) {
            return String(line[match])
        }
        return nil
    }

    private static func parseDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.date(from: string)
    }

    private static func isAge17OrMore(birthDate: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        if let age = calendar.dateComponents([.year], from: birthDate, to: now).year {
            return age >= 17
        }
        return false
    }

    /// Debug
    func printSummary() {
        print("NIK:", self.nik ?? "-")
        print("Name:", self.name ?? "-")
        print("Birth Place:", self.birthPlace ?? "-")
        print("Birth Date:", self.birthDate ?? "-")
        print("Gender:", self.gender ?? "-")
        print("Address:", self.address ?? "-")
        print("RT/RW:", self.rtRw ?? "-")
        print("Kelurahan:", self.kelurahan ?? "-")
        print("Kecamatan:", self.kecamatan ?? "-")
        print("Pekerjaan:", self.pekerjaan ?? "-")
        print("Kewarganegaraan:", self.kewarganegaraan ?? "-")
        print("Status Perkawinan:", self.statusPerkawinan ?? "-")
    }
}

//
//  PersonalInfoViewModel.swift
//  Fort
//
//  Created by William on 23/07/25.
//

import Foundation

class PersonalInfoViewModel : ObservableObject {
    let ocrResult : OCRResult
    
    init(ocrResult: OCRResult) {
        self.ocrResult = ocrResult
        onInitialize()
    }
}

private extension PersonalInfoViewModel {
    func onInitialize() {
        //TODO: fill in all OCRResult to a new Model for user
        print(ocrResult.printSummary())
    }
}

//
//  LanguageModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 03/05/2024.
//

import Foundation

struct LanguageModel: Identifiable, Hashable, Comparable, Codable {
    static func < (lhs: LanguageModel, rhs: LanguageModel) -> Bool {
        lhs.id < rhs.id
    }
    
    let id: String
    let flag: String
    let sourceCode: String
    let targetCode: String
    let ttsCode: String
    let ttsGender: String
    let ttsVoice: String
}

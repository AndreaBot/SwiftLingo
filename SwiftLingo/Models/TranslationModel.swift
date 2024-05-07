//
//  TranslationModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import Foundation

struct TranslationModel: Identifiable, Codable {
    let id: Double
    let sourceLanguage: LanguageModel
    let targetLanguage: LanguageModel
    let textToTranslate: String
    let translation: String
}

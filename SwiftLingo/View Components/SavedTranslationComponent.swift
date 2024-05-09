//
//  SavedTranslationComponent.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI

struct SavedTranslationComponent: View {
    
    let savedTranslation: TranslationModel
    
    var body: some View {
        HStack {
            Text(savedTranslation.sourceLanguage.flag)
            Text(savedTranslation.textToTranslate)
                .lineLimit(1)
            Spacer()
            Text(savedTranslation.translation)
                .lineLimit(1)
            Text(savedTranslation.targetLanguage.flag)
        }
        .padding()
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    let sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB")
    let targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT")
    let saved = TranslationModel(id: 0.2, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, textToTranslate: "Coffee", translation: "Caffe'")
   
    return SavedTranslationComponent(savedTranslation: saved)
}

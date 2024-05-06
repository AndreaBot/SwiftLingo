//
//  SavedTranslationsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import FirebaseAuth
import SwiftUI

struct SavedTranslationsView: View {
    
    
    let currentUser = Auth.auth().currentUser
    
    // var savedTranslations: [TranslationModel] = []
    
    let savedTranslations = [
        TranslationModel(id: 0.1, sourceLanguage:   LanguageModel(id: "Bulgarian", flag: "🇧🇬", sourceCode: "BG", targetCode: "BG", ttsCode: "bg-BG", ttsGender: "FEMALE", ttsVoice: "bg-BG-Standard-A"), targetLanguage: LanguageModel(id: "Czech", flag: "🇨🇿", sourceCode: "CS", targetCode: "CS", ttsCode: "cs-CZ", ttsGender: "FEMALE", ttsVoice: "cs-CZ-Standard-A"), textToTranslate: "Test 1", translation: "1 Test"),
        TranslationModel(id: 0.2, sourceLanguage:  LanguageModel(id: "Greek", flag: "🇬🇷", sourceCode: "EL", targetCode: "EL", ttsCode: "el-GR", ttsGender: "FEMALE", ttsVoice: "el-GR-Standard-A"), targetLanguage:  LanguageModel(id: "Spanish", flag: "🇪🇸", sourceCode: "ES", targetCode: "ES", ttsCode: "es-ES", ttsGender: "FEMALE", ttsVoice: "es-ES-Standard-C"), textToTranslate: "Test 2", translation: "2 Test")
    ]
    
    var body: some View {
        if let currentUser = currentUser {
            List {
                ForEach(savedTranslations) { translation in
                    SavedTranslationComponent(savedTranslation: translation)
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 2.5, leading: 5, bottom: 2.5, trailing: 5))
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
            .listRowSpacing(5)
            
        } else {
            ContentUnavailableView("Oops...", systemImage: "multiply", description: Text("You need to be logged in as a user to save and access your translations"))
        }
    }
}

#Preview {
//    let saved = [
//        TranslationModel(id: 0.1, sourceLanguage:   LanguageModel(id: "Bulgarian", flag: "🇧🇬", sourceCode: "BG", targetCode: "BG", ttsCode: "bg-BG", ttsGender: "FEMALE", ttsVoice: "bg-BG-Standard-A"), targetLanguage: LanguageModel(id: "Czech", flag: "🇨🇿", sourceCode: "CS", targetCode: "CS", ttsCode: "cs-CZ", ttsGender: "FEMALE", ttsVoice: "cs-CZ-Standard-A"), textToTranslate: "Test 1", translation: "1 Test"),
//        TranslationModel(id: 0.2, sourceLanguage:  LanguageModel(id: "Greek", flag: "🇬🇷", sourceCode: "EL", targetCode: "EL", ttsCode: "el-GR", ttsGender: "FEMALE", ttsVoice: "el-GR-Standard-A"), targetLanguage:  LanguageModel(id: "Spanish", flag: "🇪🇸", sourceCode: "ES", targetCode: "ES", ttsCode: "es-ES", ttsGender: "FEMALE", ttsVoice: "es-ES-Standard-C"), textToTranslate: "Test 2", translation: "2 Test")
//    ]
     SavedTranslationsView()
}

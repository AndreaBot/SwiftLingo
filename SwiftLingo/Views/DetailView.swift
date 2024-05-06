//
//  DetailView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI

struct DetailView: View {
    
    @State private var ttsViewModel = TTSViewModel()
    let savedTranslation: TranslationModel
    
    var body: some View {
        VStack {
            VStack {
                Text(savedTranslation.sourceLanguage.flag + savedTranslation.sourceLanguage.id)
                Text(savedTranslation.textToTranslate)
            }
            
            Spacer()
            
            VStack {
                Text(savedTranslation.targetLanguage.flag + savedTranslation.targetLanguage.id)
                Text(savedTranslation.translation)
            }
            
            Spacer()
            
            HStack {
                Button {
                    Task {
                        await ttsViewModel.generateVoice(text: savedTranslation.translation,
                                                         languageCode: savedTranslation.targetLanguage.ttsCode,
                                                         name: savedTranslation.targetLanguage.ttsVoice,
                                                         ssmlGender: savedTranslation.targetLanguage.ttsGender)
                    }
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                }
                Spacer()
                Button {
                    print("delete")
                } label: {
                    Image(systemName: "trash.fill")
                }
            }
        }
        .containerRelativeFrame(.horizontal) { size, axis in
            size
        }
        .background(.thickMaterial)
    }
}

#Preview {
    let sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB", ttsGender: "FEMALE", ttsVoice: "en-GB-Standard-C")
    let targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT", ttsGender: "FEMALE", ttsVoice: "it-IT-Standard-A")
    let saved = TranslationModel(id: 0.2, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, textToTranslate: "Coffee", translation: "Caffe'")
    
    return DetailView(savedTranslation: saved)
}

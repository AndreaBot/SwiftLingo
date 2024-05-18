//
//  TranslatorUtilityButtons.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 18/05/2024.
//

import SwiftUI

struct TranslatorUtilityButtons: View {
    
    @Binding var translatorViewModel: TranslatorViewModel
    @Binding var ttsViewModel: TTSViewModel
    @Binding var firestoreViewModel: FirestoreViewModel
    
    var body: some View {
        HStack {
            Button {
                ttsViewModel.readTranslation(text: translatorViewModel.translation, language: translatorViewModel.targetLanguage.ttsCode, speed: 0.5)
            } label: {
                Image(systemName: ttsViewModel.isSpeaking ? "speaker.wave.3.fill" : "speaker")
                    .fontWeight(.medium)
                    .tint(translatorViewModel.translation.isEmpty ? .primary : .blue)
                    .symbolEffect(ttsViewModel.isSpeaking ? .variableColor.iterative.dimInactiveLayers.nonReversing : .variableColor, options: ttsViewModel.isSpeaking ? .repeating : .nonRepeating, value: ttsViewModel.isSpeaking)
            }
            .contentTransition(.symbolEffect(.replace))
            .disabled(translatorViewModel.translation.isEmpty)
            
            Button {
                ttsViewModel.readTranslation(text: translatorViewModel.translation, language: translatorViewModel.targetLanguage.ttsCode, speed: 0.1)
            } label: {
                Image(systemName: "tortoise")
                    .fontWeight(.medium)
                    .tint(translatorViewModel.translation.isEmpty ? .primary : .green)
                    .symbolEffect(.pulse.wholeSymbol, options: ttsViewModel.isSpeakingSlow ? .repeating : .default, value: ttsViewModel.isSpeakingSlow)
            }
            .disabled(translatorViewModel.translation.isEmpty)
            
            Button {
                Task {
                    await firestoreViewModel.saveTranslation(sourceLanguage: translatorViewModel.sourceLanguage.id, textToTranslate: translatorViewModel.textToTranslate, targetLanguage: translatorViewModel.targetLanguage.id, translation: translatorViewModel.translation)
                }
            } label: {
               Image(systemName: firestoreViewModel.translationSaved ? "heart.fill" : "heart")
                    .fontWeight(.medium)
                    .tint(.red)
            }
            .disabled(translatorViewModel.translation.isEmpty)
            .contentTransition(.symbolEffect(.replace))
        }
    }
}

//#Preview {
//    TranslatorUtilityButtons()
//}

//
//  DetailView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI
import AVFoundation

struct DetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var ttsViewModel = TTSViewModel()
    
    let savedTranslation: TranslationModel
    var deleteFromFirestore: (() async -> Void)?
    var deleteFromUserDefaults: (() -> Void)?
    
    let showingFirebaseTranslations: Bool
    
    
    var body: some View {
        VStack(spacing: 0) {
            DismissToolbar(dismissAction: dismiss)
            
            VStack {
                Text("\(savedTranslation.sourceLanguage.flag) \(savedTranslation.sourceLanguage.id)")
                    .fontWeight(.semibold)
                Divider()
                    .background(.blue)
                    .frame(height: 10)
                Text(savedTranslation.textToTranslate)
            }
            
            Spacer()
            
            VStack {
                Text("\(savedTranslation.targetLanguage.flag) \(savedTranslation.targetLanguage.id)")
                    .fontWeight(.semibold)
                Divider()
                    .background(.blue)
                    .frame(height: 10)
                Text(savedTranslation.translation)
            }
            
            Spacer()
            
            HStack {
                Button {
                    ttsViewModel.readTranslation(text: savedTranslation.translation, language: savedTranslation.targetLanguage.ttsCode, speed: 0.1)
                } label: {
                    Image(systemName: "tortoise.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.background)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .symbolEffect(.pulse.wholeSymbol, options: ttsViewModel.isSpeakingSlow ? .repeating : .default, value: ttsViewModel.isSpeakingSlow)
                }
                
                Button {
                    ttsViewModel.readTranslation(text: savedTranslation.translation, language: savedTranslation.targetLanguage.ttsCode, speed: 0.5)
                } label: {
                    Image(systemName: ttsViewModel.isSpeaking ? "speaker.wave.3.fill" : "speaker")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.background)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .symbolEffect(ttsViewModel.isSpeaking ? .variableColor.iterative.dimInactiveLayers.nonReversing : .variableColor, options: ttsViewModel.isSpeaking ? .repeating : .default, value: ttsViewModel.isSpeaking)
                }
                .contentTransition(.symbolEffect(.replace))
                
                Spacer()
                Button {
                    if showingFirebaseTranslations {
                        Task {
                            if let deleteFromFirestore = deleteFromFirestore {
                                await deleteFromFirestore()
                            }
                        }
                    } else {
                        if let deleteFromUserDefaults = deleteFromUserDefaults {
                            deleteFromUserDefaults()
                        }
                    }
                    dismiss()
                } label: {
                    Image(systemName: "trash.fill")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.background)
                        .background(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(.thickMaterial)
    }
}

#Preview {
    let sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB")
    let targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT")
    let saved = TranslationModel(id: 0.2, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, textToTranslate: "Coffee", translation: "Caffe'")
    
    return DetailView(savedTranslation: saved, showingFirebaseTranslations: false)
}

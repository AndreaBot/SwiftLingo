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
        VStack {
            DismissToolbar(dismissAction: dismiss)
            
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
                    ttsViewModel.readTranslation(text: savedTranslation.translation, language: savedTranslation.targetLanguage.ttsCode)
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                }
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
                }
            }
        }
        .padding()
        .containerRelativeFrame(.horizontal) { size, axis in
            size
        }
        .background(.thickMaterial)
    }
}

//#Preview {
//    let sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB")
//    let targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT")
//    let saved = TranslationModel(id: 0.2, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage, textToTranslate: "Coffee", translation: "Caffe'")
//
//    return DetailView(savedTranslation: saved)
//}

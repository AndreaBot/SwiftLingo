//
//  TranslatorView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 03/05/2024.
//

import SwiftUI

struct TranslatorView: View {
    
    @Binding var firestoreViewModel: FirestoreViewModel
    @State private var translatorViewModel = TranslatorViewModel()
    @State private var ttsViewModel = TTSViewModel()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Translate")
                TextEditor(text: $translatorViewModel.textToTranslate)
                
            }
            Form {
                VStack(spacing: 20) {
                    Picker("Select source language", selection: $translatorViewModel.sourceLanguage) {
                        ForEach(TranslatorViewModel.allLanguages.sorted()) {
                            Text($0.id)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    Picker("Select target language", selection: $translatorViewModel.targetLanguage) {
                        ForEach(TranslatorViewModel.allLanguages.sorted()) {
                            Text($0.id)
                                .tag($0)
                        }
                    }
                    Section {
                        Button("Translate") {
                            Task {
                                await translatorViewModel.getTranslation(text: translatorViewModel.textToTranslate,
                                                                         source: translatorViewModel.sourceLanguage.sourceCode,
                                                                         target: translatorViewModel.targetLanguage.targetCode)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Translation")
                    
                    Spacer()
                    
                    Button {
                        firestoreViewModel.saveTranslation(sourceLanguage: translatorViewModel.sourceLanguage.id, textToTranslate: translatorViewModel.textToTranslate, targetLanguage: translatorViewModel.targetLanguage.id, translation: translatorViewModel.translation)
                    } label: {
                        Image(systemName: "heart")
                            .tint(.pink)
                    }
                    .disabled(translatorViewModel.translation.isEmpty)
                    
                    Button {
                        Task {
                            await ttsViewModel.generateVoice(text: translatorViewModel.translation,
                                                             languageCode: translatorViewModel.targetLanguage.ttsCode,
                                                             name: translatorViewModel.targetLanguage.ttsVoice,
                                                             ssmlGender: translatorViewModel.targetLanguage.ttsGender)
                        }
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .disabled(translatorViewModel.translation.isEmpty)
                }
                TextEditor(text: $translatorViewModel.translation)
            }
        }
        .alert("Error", isPresented: $firestoreViewModel.showingAlert) {
        } message: {
            Text(firestoreViewModel.alertMessage)
        }
    }
}

//#Preview {
//    TranslatorView()
//}

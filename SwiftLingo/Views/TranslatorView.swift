//
//  TranslatorView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 03/05/2024.
//

import SwiftUI
import AVFoundation

struct TranslatorView: View {
    
    @Binding var firestoreViewModel: FirestoreViewModel
    @Binding var translatorViewModel: TranslatorViewModel
    @State private var ttsViewModel = TTSViewModel()
    //    @State private var translationSaved = false
    @FocusState var focus: Bool
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Translate")
                    TextEditor(text: $translatorViewModel.textToTranslate)
                        .autocorrectionDisabled()
                        .focused($focus)
                        .onChange(of: focus) {
                            if focus {
                                translatorViewModel.textToTranslate = ""
                            }
                        }
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
                                translatorViewModel.checkForNewLines()
                                Task {
                                    firestoreViewModel.translationSaved = false
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
                            Image(systemName: firestoreViewModel.translationSaved ? "heart.fill": "heart")
                                .tint(firestoreViewModel.translationSaved ? .red : .primary)
                        }
                        .disabled(translatorViewModel.translation.isEmpty)
                        .contentTransition(.symbolEffect(.replace))
                        
                        Button {
                            ttsViewModel.readTranslation(text: translatorViewModel.translation, language: translatorViewModel.targetLanguage.ttsCode)
                        } label: {
                            Image(systemName: ttsViewModel.isSpeaking ? "speaker.wave.3.fill" : "speaker")
                                .foregroundStyle(.blue)
                                .symbolEffect(ttsViewModel.isSpeaking ? .variableColor.iterative.dimInactiveLayers.nonReversing : .variableColor, options: ttsViewModel.isSpeaking ? .repeating : .nonRepeating, value: ttsViewModel.isSpeaking)
                        }
                        .contentTransition(.symbolEffect(.replace))
                        .disabled(translatorViewModel.translation.isEmpty)
                    }
                    TextEditor(text: $translatorViewModel.translation)
                        .disabled(true)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button("Done") {
                            focus = false
                        }
                    }
                }
            }
            .alert("Error", isPresented: $firestoreViewModel.showingAlert) {
            } message: {
                Text(firestoreViewModel.alertMessage)
            }
        }
        .onAppear {
            translatorViewModel.loadDefaultLanguages()
            //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        }
        .onChange(of: translatorViewModel.sourceLanguage) { _, _ in
            translatorViewModel.setDefaultValue(valueToStore: translatorViewModel.sourceLanguage, key: "defaultSourceLanguage")
        }
        .onChange(of: translatorViewModel.targetLanguage) { _, _ in
            translatorViewModel.setDefaultValue(valueToStore: translatorViewModel.targetLanguage, key: "defaultTargetLanguage")
        }
        .onChange(of: translatorViewModel.history) { _, _ in
            translatorViewModel.setDefaultValue(valueToStore: translatorViewModel.history, key: "history")
        }
    }
}

//#Preview {
//    TranslatorView()
//}

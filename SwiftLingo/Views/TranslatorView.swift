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
    @FocusState var focus: Bool
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("What would you like to translate?")
                        TextEditor(text: $translatorViewModel.textToTranslate)
                            .autocorrectionDisabled()
                            .focused($focus)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.clear)
                                    .stroke(.blue, lineWidth: 2 )
                            }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack(spacing: 15) {
                            Text("Translation")
                            
                            Spacer()
                            
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
                                  await  firestoreViewModel.saveTranslation(sourceLanguage: translatorViewModel.sourceLanguage.id, textToTranslate: translatorViewModel.textToTranslate, targetLanguage: translatorViewModel.targetLanguage.id, translation: translatorViewModel.translation)
                                }
                            } label: {
                                Image(systemName: firestoreViewModel.translationSaved ? "heart.fill": "heart")
                                    .fontWeight(.medium)
                                    .tint(.red)
                            }
                            .disabled(translatorViewModel.translation.isEmpty)
                            .contentTransition(.symbolEffect(.replace))
                        }
                        
                        TextEditor(text: $translatorViewModel.translation)
                            .disabled(true)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.clear)
                                    .stroke(.blue, lineWidth: 2 )
                            }
                    }
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Picker("", selection: $translatorViewModel.sourceLanguage) {
                                ForEach(TranslatorViewModel.allLanguages.sorted()) {
                                    Text($0.id)
                                    
                                        .tag($0)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .tint(.primary)
                            .background(.secondary.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                            
                            Button {
                                translatorViewModel.swapLanguages()
                            } label: {
                                Image(systemName: "arrow.left.arrow.right")
                            }
                            
                            Picker("", selection: $translatorViewModel.targetLanguage) {
                                ForEach(TranslatorViewModel.allLanguages.sorted()) {
                                    Text($0.id)
                                        .tag($0)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .tint(.primary)
                            .background(.secondary.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .pickerStyle(.automatic)
                        
                        Button {
                            translatorViewModel.checkForNewLines()
                            Task {
                                firestoreViewModel.translationSaved = false
                                await translatorViewModel.getTranslation(text: translatorViewModel.textToTranslate,
                                                                         source: translatorViewModel.sourceLanguage.sourceCode,
                                                                         target: translatorViewModel.targetLanguage.targetCode)
                            }
                        } label: {
                            Text("Translate")
                                .frame(maxWidth: .infinity)
                        }
                        .foregroundStyle(.background)
                        .customButton(fillColor: .blue, borderWidth: 0)
                    }
                }
                .padding()
                
                
                if firestoreViewModel.showingConfirmationMessage {
                    ConfirmationMessageView(message: "Translation saved successfully!")
                        .transition(.opacity)
                }
            }
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
}

#Preview {
    TranslatorView(firestoreViewModel: .constant(FirestoreViewModel()), translatorViewModel: .constant(TranslatorViewModel()))
}

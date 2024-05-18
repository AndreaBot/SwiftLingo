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
    
    @State private var isAnimatingPlaceholder = false
    
    
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
                            TranslatorUtilityButtons(translatorViewModel: $translatorViewModel, ttsViewModel: $ttsViewModel, firestoreViewModel: $firestoreViewModel)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $translatorViewModel.translation)
                                .disabled(true)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.clear)
                                        .stroke(.blue, lineWidth: 2 )
                                }
                            if translatorViewModel.isLoadingTranslation  {
                                Image(systemName: "ellipsis")
                                    .font(.headline)
                                    .padding()
                                    .symbolEffect(.variableColor.iterative.hideInactiveLayers.nonReversing, options: .repeating, value: isAnimatingPlaceholder)
                                    .transition(.opacity)
                                    .onAppear {
                                        isAnimatingPlaceholder = true
                                    }
                                    .onDisappear {
                                        isAnimatingPlaceholder = false
                                    }
                            }
                        }
                    }
                    
                    VStack(spacing: 20) {
                        LanguagesPickersStackView(translatorViewModel: $translatorViewModel)
                        
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
                translatorViewModel.translation = ""
            }
            .onChange(of: translatorViewModel.targetLanguage) { _, _ in
                translatorViewModel.setDefaultValue(valueToStore: translatorViewModel.targetLanguage, key: "defaultTargetLanguage")
                translatorViewModel.translation = ""
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

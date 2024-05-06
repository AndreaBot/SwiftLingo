//
//  TranslatorView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 03/05/2024.
//

import SwiftUI

struct TranslatorView: View {
    
    @State private var viewModel = TranslatorViewModel()
    @State private var ttsViewModel = TTSViewModel()
    
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Translate")
                TextEditor(text: $viewModel.textToTranslate)
                
            }
            Form {
                VStack(spacing: 20) {
                    Picker("Select source language", selection: $viewModel.sourceLanguage) {
                        ForEach(viewModel.allLanguages.sorted()) {
                            Text($0.id)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.automatic)
                    Picker("Select target language", selection: $viewModel.targetLanguage) {
                        ForEach(viewModel.allLanguages.sorted()) {
                            Text($0.id)
                                .tag($0)
                        }
                    }
                    Section {
                        Button("Translate") {
                            Task {
                                await viewModel.getTranslation(text: viewModel.textToTranslate,
                                                               source: viewModel.sourceLanguage.sourceCode,
                                                               target: viewModel.targetLanguage.targetCode)
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
                        guard viewModel.userId != nil  else {
                            alertMessage = "You need to be logged in as a user to save tranlsations."
                            showingAlert = true
                            return
                            }
                        viewModel.saveTranslation()
                    } label: {
                        Image(systemName: "heart")
                            .tint(.pink)
                    }
                    .disabled(viewModel.translation.isEmpty)
                    
                    Button {
                        Task {
                            await ttsViewModel.generateVoice(text: viewModel.translation,
                                                             languageCode: viewModel.targetLanguage.ttsCode,
                                                             name: viewModel.targetLanguage.ttsVoice,
                                                             ssmlGender: viewModel.targetLanguage.ttsGender)
                        }
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .disabled(viewModel.translation.isEmpty)
                }
                TextEditor(text: $viewModel.translation)
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            
        }
    }
}

#Preview {
    TranslatorView()
}

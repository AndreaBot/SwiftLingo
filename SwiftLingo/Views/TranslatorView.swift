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
                        Button("TRANSLATE") {
                            Task {
                                await viewModel.getTranslation(text: viewModel.textToTranslate,
                                                               source: viewModel.sourceLanguage.sourceCode,
                                                               target: viewModel.targetLanguage.targetCode)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        
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
                        Task {
                            await ttsViewModel.generateVoice(text: viewModel.translation,
                                                             languageCode: viewModel.targetLanguage.ttsCode,
                                                             name: viewModel.targetLanguage.ttsVoice,
                                                             ssmlGender: viewModel.targetLanguage.ttsGender)
                        }
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                    }
                    .disabled(viewModel.translation == "")
                }
                TextEditor(text: $viewModel.translation)
                
            }
        }
    }
}

#Preview {
    TranslatorView()
}

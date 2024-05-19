//
//  LanguagesPickersStackView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 18/05/2024.
//

import SwiftUI

struct LanguagesPickersStackView: View {
    
    @Binding var translatorViewModel: TranslatorViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Picker("", selection: $translatorViewModel.sourceLanguage) {
                ForEach(TranslatorViewModel.allLanguages.sorted()) {
                    Text($0.id)
                    
                        .tag($0)
                }
            }
            .customLanguagePicker()
            
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
            .customLanguagePicker()
        }
        .pickerStyle(.automatic)
    }
}


#Preview {
    @State var translatorViewModel = TranslatorViewModel()
    return LanguagesPickersStackView(translatorViewModel: $translatorViewModel)
}

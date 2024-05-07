//
//  HistoryView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 07/05/2024.
//

import SwiftUI

struct HistoryView: View {
    
    @Binding var translatorViewModel: TranslatorViewModel
    @State private var selectedTranslation: TranslationModel?
    
    var body: some View {
        if !translatorViewModel.history.isEmpty {
            List {
                ForEach(translatorViewModel.history.sorted()) { translation in
                    Button {
                        selectedTranslation = translation
                    } label: {
                        SavedTranslationComponent(savedTranslation: translation)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        translatorViewModel.deleteUserDefaultValue(translation: translatorViewModel.history[index])
                    }
                })
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 2.5, leading: 5, bottom: 2.5, trailing: 5))
            }
            .padding()
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
            .listRowSpacing(5)
            .sheet(item: $selectedTranslation) { translation in
                DetailView(savedTranslation: translation, deleteFromUserDefaults: {
                    translatorViewModel.deleteUserDefaultValue(translation: translation)
                }, showingFirebaseTranslations: false)
            }
        } else {
            ContentUnavailableView("Oops, nothing to see here...", systemImage: "ellipsis", description: Text("Your 10 most recent translations will automatically appear here."))
        }
    }
}

//#Preview {
//    HistoryView()
//}

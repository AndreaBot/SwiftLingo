//
//  HistoryView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 07/05/2024.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var translatorViewModel: TranslatorViewModel
    @Binding var firestoreViewModel: FirestoreViewModel
    @State private var selectedTranslation: TranslationModel?
    
    var body: some View {
        VStack {
            HStack {
                Text("History")
                    .font(.title)
                    .fontDesign(.rounded)
                DismissToolbar(dismissAction: dismiss)
            }
            if !translatorViewModel.history.isEmpty {
                
                List {
                    ForEach(translatorViewModel.history.sorted()) { translation in
                        Button {
                            selectedTranslation = translation
                        } label: {
                            SavedTranslationComponent(savedTranslation: translation)
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                            if let currentUser = firestoreViewModel.currentUser {
                                Button {
                                    firestoreViewModel.saveTranslation(sourceLanguage: translation.sourceLanguage.id, textToTranslate: translation.textToTranslate, targetLanguage: translation.targetLanguage.id, translation: translation.translation)
                                } label: {
                                    Image(systemName: "heart")
                                }
                                .tint(.blue)
                            }
                        })
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            translatorViewModel.deleteHistoryUserDefaultValue(translation: translatorViewModel.history[index])
                        }
                    })
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 2.5, leading: 5, bottom: 2.5, trailing: 5))
                }
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 0)
                .listRowSpacing(5)
                .sheet(item: $selectedTranslation) { translation in
                    DetailView(savedTranslation: translation, deleteFromUserDefaults: {
                        translatorViewModel.deleteHistoryUserDefaultValue(translation: translation)
                    }, showingFirebaseTranslations: false)
                    .presentationDetents([.medium])
                }
                
            } else {
                ContentUnavailableView("Oops, nothing to see here...", systemImage: "ellipsis", description: Text("Your 10 most recent translations will automatically appear here."))
            }
        }
        .padding()
    }
}

//#Preview {
//    HistoryView()
//}

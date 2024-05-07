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
        List {
            ForEach(translatorViewModel.history) { translation in
                Button {
                    selectedTranslation = translation
                } label: {
                    SavedTranslationComponent(savedTranslation: translation)
                }
            }
            .onDelete(perform: { indexSet in
                print("deleted!")
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
                print("Deleted!")
            }, showingFirebaseTranslations: false)
        }
    }
}

//#Preview {
//    HistoryView()
//}

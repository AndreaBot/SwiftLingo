//
//  SavedTranslationsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI

struct SavedTranslationsView: View {
    
    @State private var viewModel = SavedTranslationsViewModel()
    @State private var selectedTranslation: TranslationModel? = nil
    
    var body: some View {
        if let _ = viewModel.currentUser {
            List {
                ForEach(viewModel.savedTranslations) { translation in
                    Button {
                        selectedTranslation = translation
                    } label: {
                        SavedTranslationComponent(savedTranslation: translation)
                    }
                }
                .onDelete(perform: { indexSet in
                    Task {
                        for index in indexSet {
                            await viewModel.deleteTranslation(documentName: String(viewModel.savedTranslations[index].id))
                            viewModel.fetchTranslations()
                        }
                    }
                })
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 2.5, leading: 5, bottom: 2.5, trailing: 5))
                
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
            .listRowSpacing(5)
            .onAppear {
                viewModel.fetchTranslations()
            }
            .sheet(item: $selectedTranslation, onDismiss: {
                viewModel.fetchTranslations()
            }) { translation in
                DetailView(savedTranslation: translation)
                    .presentationDetents([.medium])
            }
            
        } else {
            ContentUnavailableView("Oops...", systemImage: "multiply", description: Text("You need to be logged in as a user to save and access your translations"))
        }
           
    }
        
}

#Preview {
    SavedTranslationsView()
}

//
//  SavedTranslationsView.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import SwiftUI

struct SavedTranslationsView: View {
    
    @Binding var firestoreViewModel: FirestoreViewModel
    @State private var selectedTranslation: TranslationModel? = nil
    
    var body: some View {
        VStack {
            if let _ = firestoreViewModel.currentUser {
                if !firestoreViewModel.savedTranslations.isEmpty {
                    List {
                        ForEach(firestoreViewModel.savedTranslations) { translation in
                            Button {
                                selectedTranslation = translation
                            } label: {
                                SavedTranslationComponent(savedTranslation: translation)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            Task {
                                for index in indexSet {
                                    await firestoreViewModel.deleteTranslation(documentName: String(firestoreViewModel.savedTranslations[index].id))
                                    firestoreViewModel.fetchTranslations()
                                }
                            }
                        })
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 2.5, leading: 5, bottom: 2.5, trailing: 5))
                        
                    }
                    .listStyle(.plain)
                    .environment(\.defaultMinListRowHeight, 0)
                    .listRowSpacing(5)
                    .sheet(item: $selectedTranslation, onDismiss: {
                        firestoreViewModel.fetchTranslations()
                    }) { translation in
                        DetailView(savedTranslation: translation, deleteFromFirestore: {
                            await firestoreViewModel.deleteTranslation(documentName: String(translation.id))
                        }, showingFirebaseTranslations: true)
                        .presentationDetents([.medium])
                    }
                    .alert("Error", isPresented: $firestoreViewModel.showingAlert) {
                    } message: {
                        Text(firestoreViewModel.alertMessage)
                    }
                } else {
                    ContentUnavailableView("Oops, nothing to see here...", systemImage: "heart.slash", description: Text("Save your translations to see them listed here."))
                }
                
            } else {
                ContentUnavailableView("Oops...", systemImage: "multiply", description: Text("You need to be logged in as a user to save and access your translations"))
            }
        }
        .onAppear {
            firestoreViewModel.fetchTranslations()
        }
        
    }
    
}

//#Preview {
//    SavedTranslationsView()
//}

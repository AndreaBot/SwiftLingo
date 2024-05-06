//
//  SavedTranslationsViewModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

@Observable
final class SavedTranslationsViewModel {
    
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var savedTranslations: [TranslationModel] = []
    
    func fetchTranslations() {
        if let currentUser = currentUser {
            database.collection(currentUser.uid)
                .order(by: "date", descending: true)
                .getDocuments { [self] (querySnapshot, error) in
                    
                    savedTranslations = []
                    
                    if let e = error {
                        print("the was an issue retrieving data \(e)")
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let date = data["date"] as? Double,
                                   let sourceLang = data["sourceLanguage"] as? String,
                                   let textToTranslate = data["textToTranslate"] as? String,
                                   let targetLanguage = data["targetLanguage"] as? String,
                                   let translation = data["translation"] as? String
                                {
                                    
                                    if let sourceLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
                                        languageModel.id == sourceLang
                                    }), let targetLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
                                        languageModel.id == targetLanguage
                                    }) {
                                        
                                        let fetchedTranslation = TranslationModel(id: date, sourceLanguage: TranslatorViewModel.allLanguages[sourceLangIndex], targetLanguage: TranslatorViewModel.allLanguages[targetLangIndex], textToTranslate: textToTranslate, translation: translation)
                                        
                                        savedTranslations.append(fetchedTranslation)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
}


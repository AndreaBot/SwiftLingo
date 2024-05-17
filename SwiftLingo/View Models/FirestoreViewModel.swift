//
//  SavedTranslationsViewModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 06/05/2024.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI

@Observable
final class FirestoreViewModel {
    
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser
    
    var savedTranslations: [TranslationModel] = []
    
    var alertMessage = ""
    var showingAlert = false
    var translationSaved = false
    var showingConfirmationMessage = false
    
    func fetchTranslations() {
        if let currentUser = currentUser {
            database.collection(currentUser.uid)
                .order(by: "date", descending: true)
                .getDocuments { (querySnapshot, error) in
                    
                    self.savedTranslations = []
                    
                    if let error = error as NSError? {
                        if let code = FirestoreErrorCode.Code(rawValue: error.code) {
                            self.alertMessage = FirestoreErrors.presentError(using: code)
                            self.showingAlert = true
                        }
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
                                        
                                        self.savedTranslations.append(fetchedTranslation)
                                    }
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func saveTranslation(sourceLanguage: String, textToTranslate: String, targetLanguage: String, translation: String) async {
        guard currentUser != nil  else {
            alertMessage = "You must be logged in as a user to save translations."
            showingAlert = true
            return
        }
        
        if let currentUser = currentUser {
            let date = Date().timeIntervalSince1970
            do {
                try await database.collection(currentUser.uid).document(String(date)).setData([
                    "sourceLanguage": sourceLanguage,
                    "textToTranslate": textToTranslate,
                    "targetLanguage" : targetLanguage,
                    "translation": translation,
                    "date": date
                ])
                self.translationSaved = true
                self.showAndHideMessage()
                
                
            } catch {
                if let error = error as NSError? {
                    if let code = FirestoreErrorCode.Code(rawValue: error.code) {
                        self.alertMessage = FirestoreErrors.presentError(using: code)
                        self.showingAlert = true
                    }
                }
            }
        }
    }
    
    func deleteTranslation(documentName: String) async {
        if let currentUser = currentUser {
            do {
                try await database.collection(currentUser.uid).document(documentName).delete()
            } catch {
                if let error = error as NSError? {
                    if let code = FirestoreErrorCode.Code(rawValue: error.code) {
                        self.alertMessage = FirestoreErrors.presentError(using: code)
                        self.showingAlert = true
                    }
                }
            }
        }
    }
    
    func showAndHideMessage() {
        withAnimation(.smooth(duration: 0.6)) {
            showingConfirmationMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.smooth(duration: 0.6)) {
                self.showingConfirmationMessage = false
            }
        }
    }
}

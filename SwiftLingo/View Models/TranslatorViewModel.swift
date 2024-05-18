//
//  TranslatorViewModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 03/05/2024.
//

import FirebaseAuth
import FirebaseFirestore
import SwiftUI


@Observable
final class TranslatorViewModel {
    
    static let allLanguages: [LanguageModel] = [
        LanguageModel(id: "Arabic", flag: "🇸🇦", sourceCode: "AR", targetCode: "AR", ttsCode: "ar-001"),
        LanguageModel(id: "Bulgarian", flag: "🇧🇬", sourceCode: "BG", targetCode: "BG", ttsCode: "bg-BG"),
        LanguageModel(id: "Czech", flag: "🇨🇿", sourceCode: "CS", targetCode: "CS", ttsCode: "cs-CZ"),
        LanguageModel(id: "Danish", flag: "🇩🇰", sourceCode: "DA", targetCode: "DA", ttsCode: "da-DK"),
        LanguageModel(id: "German", flag: "🇩🇪", sourceCode: "DE", targetCode: "DE", ttsCode: "de-DE"),
        LanguageModel(id: "Greek", flag: "🇬🇷", sourceCode: "EL", targetCode: "EL", ttsCode: "el-GR"),
        LanguageModel(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB"),
        LanguageModel(id: "Spanish", flag: "🇪🇸", sourceCode: "ES", targetCode: "ES", ttsCode: "es-ES"),
        LanguageModel(id: "Finnish", flag: "🇫🇮", sourceCode: "FI", targetCode: "FI", ttsCode: "fi-FI"),
        LanguageModel(id: "French", flag: "🇫🇷", sourceCode: "FR", targetCode: "FR", ttsCode: "fr-FR"),
        LanguageModel(id: "Hungarian", flag: "🇭🇺", sourceCode: "HU", targetCode: "HU", ttsCode: "hu-HU"),
        LanguageModel(id: "Indonesian", flag: "🇮🇩", sourceCode: "ID", targetCode: "ID", ttsCode: "id-ID"),
        LanguageModel(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT"),
        LanguageModel(id: "Japanese", flag: "🇯🇵", sourceCode: "JA", targetCode: "JA", ttsCode: "ja-JP"),
        LanguageModel(id: "Korean", flag: "🇰🇷", sourceCode: "KO", targetCode: "KO", ttsCode: "ko-KR"),
        LanguageModel(id: "Lithuanian", flag: "🇱🇹", sourceCode: "LT", targetCode: "LT", ttsCode: "lt-LT"),
        LanguageModel(id: "Latvian", flag: "🇱🇻", sourceCode: "LV", targetCode: "LV", ttsCode: "lv-LV"),
        LanguageModel(id: "Norwegian", flag: "🇳🇴", sourceCode: "NB", targetCode: "NB", ttsCode: "nb-NO"),
        LanguageModel(id: "Dutch", flag: "🇳🇱", sourceCode: "NL", targetCode: "NL", ttsCode: "nl-NL"),
        LanguageModel(id: "Polish", flag: "🇵🇱", sourceCode: "PL", targetCode: "PL", ttsCode: "pl-PL"),
        LanguageModel(id: "Portugese (PT)", flag: "🇵🇹", sourceCode: "PT", targetCode: "PT-PT", ttsCode: "pt-PT"),
        LanguageModel(id: "Portugese (BR)", flag: "🇧🇷", sourceCode: "PT", targetCode: "PT-BR", ttsCode: "pt-BR"),
        LanguageModel(id: "Romanian", flag: "🇷🇴", sourceCode: "RO", targetCode: "RO", ttsCode: "ro-RO"),
        LanguageModel(id: "Russian", flag: "🇷🇺", sourceCode: "RU", targetCode: "RU", ttsCode: "ru-RU"),
        LanguageModel(id: "Slovak", flag: "🇸🇰", sourceCode: "SK", targetCode: "SK", ttsCode: "sk-SK"),
        LanguageModel(id: "Swedish", flag: "🇸🇪", sourceCode: "SV", targetCode: "SV", ttsCode: "sv-SE"),
        LanguageModel(id: "Turkish", flag: "🇹🇷", sourceCode: "TR", targetCode: "TR", ttsCode: "tr-TR"),
        LanguageModel(id: "Ukrainian", flag: "🇺🇦", sourceCode: "UK", targetCode: "UK", ttsCode: "uk-UA"),
        LanguageModel(id: "Chinese", flag: "🇨🇳", sourceCode: "ZH", targetCode: "ZH", ttsCode: "zh-CN")
    ]
    
    var textToTranslate = ""
    var sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB")
    var targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT")
    var translation = "aa"
    
    var isLoadingTranslation = false
    
    
    //MARK: - API Call
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": " 415fbf1276msh25a78f8cafef37ep102f63jsn586d8d958f2b",
        "X-RapidAPI-Host": "deepl-translator.p.rapidapi.com"
    ]
    
    
    func getTranslation(text: String, source: String, target: String) async {
        let parameters = [
            "text": text,
            "source": source,
            "target": target
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://deepl-translator.p.rapidapi.com/translate")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData! as Data
        
        self.isLoadingTranslation = true
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else if let safeData = data {
                if let translatedText = self.parseJSON(safeData) {
                    self.translation = translatedText
                    self.isLoadingTranslation = false
                    self.appendToHistoryUserdefaults()
                }
            }
        })
        dataTask.resume()
    }
    
    func parseJSON(_ translationData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(TranslationData.self, from: translationData)
            let text = decodedData.text
            return text
        } catch {
            print(error)
            return nil
        }
    }
    
    func checkForNewLines() {
        for _ in textToTranslate {
            if let i = textToTranslate.firstIndex(where: { Character in
                Character.isNewline
            }) {
                textToTranslate.remove(at: i)
                textToTranslate.insert(" ", at: i)
            }
        }
    }
    
    func swapLanguages() {
        let sourceLanguageCopy = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = sourceLanguageCopy
    }
    
    
    //MARK: - UserDefaults (HistoryView)
    
    var userDef = UserDefaults.standard
    var history: [TranslationModel] = []
    
    func appendToHistoryUserdefaults() {
        if let sourceLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == sourceLanguage.id
        }), let targetLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == targetLanguage.id
        }) {
            
            let newTranslation = TranslationModel(id: Date().timeIntervalSince1970, sourceLanguage: TranslatorViewModel.allLanguages[sourceLangIndex], targetLanguage: TranslatorViewModel.allLanguages[targetLangIndex], textToTranslate: textToTranslate, translation: translation)
            
            history.append(newTranslation)
            
            CheckUserDefaultsLimit()
        }
    }
    
    func loadHistoryUserDefaults() {
        if let data = userDef.data(forKey: "history") {
            do {
                history = try JSONDecoder().decode([TranslationModel].self, from: data)
            } catch {
                print("error decoding")
            }
        }
    }
    
    func deleteHistoryUserDefaultValue(translation: TranslationModel) {
        if let index = history.firstIndex(where: { model in
            model == translation
        }) {
            history.remove(at: index)
        }
    }
    
    func CheckUserDefaultsLimit() {
        if history.count > 10 {
            history.removeFirst()
        } else {
            return
        }
    }
    
    //MARK: - UserDefaults (Remember last used languages)
    
    func loadDefaultLanguages() {
        if let savedSource = userDef.data(forKey: "defaultSourceLanguage"), let savedTarget = userDef.data(forKey: "defaultTargetLanguage") {
            do {
                sourceLanguage = try JSONDecoder().decode(LanguageModel.self, from: savedSource)
                targetLanguage = try JSONDecoder().decode(LanguageModel.self, from: savedTarget)
            } catch {
                print(error)
            }
        }
    }
    
    //MARK: - Reusable Encoding function
    
    func setDefaultValue<T: Codable>(valueToStore: T, key: String) {
        do {
            let data = try JSONEncoder().encode(valueToStore)
            userDef.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}


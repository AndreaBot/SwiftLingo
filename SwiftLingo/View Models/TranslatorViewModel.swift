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
        LanguageModel(id: "Arabic", flag: "🇸🇦", languageCode: "ar", ttsCode: "ar-001"),
        LanguageModel(id: "Bulgarian", flag: "🇧🇬", languageCode: "bg", ttsCode: "bg-BG"),
        LanguageModel(id: "Czech", flag: "🇨🇿", languageCode: "cs", ttsCode: "cs-CZ"),
        LanguageModel(id: "Danish", flag: "🇩🇰", languageCode: "da", ttsCode: "da-DK"),
        LanguageModel(id: "German", flag: "🇩🇪", languageCode: "de", ttsCode: "de-DE"),
        LanguageModel(id: "Greek", flag: "🇬🇷", languageCode: "el", ttsCode: "el-GR"),
        LanguageModel(id: "English", flag: "🇬🇧", languageCode: "en", ttsCode: "en-GB"),
        LanguageModel(id: "Spanish", flag: "🇪🇸", languageCode: "es", ttsCode: "es-ES"),
        LanguageModel(id: "Finnish", flag: "🇫🇮", languageCode: "fi", ttsCode: "fi-FI"),
        LanguageModel(id: "French", flag: "🇫🇷", languageCode: "fr", ttsCode: "fr-FR"),
        LanguageModel(id: "Hungarian", flag: "🇭🇺", languageCode: "hu", ttsCode: "hu-HU"),
        LanguageModel(id: "Indonesian", flag: "🇮🇩", languageCode: "id", ttsCode: "id-ID"),
        LanguageModel(id: "Italian", flag: "🇮🇹", languageCode: "it", ttsCode: "it-IT"),
        LanguageModel(id: "Japanese", flag: "🇯🇵", languageCode: "ja", ttsCode: "ja-JP"),
        LanguageModel(id: "Korean", flag: "🇰🇷", languageCode: "ko", ttsCode: "ko-KR"),
        LanguageModel(id: "Lithuanian", flag: "🇱🇹", languageCode: "lt", ttsCode: "lt-LT"),
        LanguageModel(id: "Latvian", flag: "🇱🇻", languageCode: "lv", ttsCode: "lv-LV"),
        LanguageModel(id: "Norwegian", flag: "🇳🇴", languageCode: "no", ttsCode: "nb-NO"),
        LanguageModel(id: "Dutch", flag: "🇳🇱", languageCode: "nl", ttsCode: "nl-NL"),
        LanguageModel(id: "Polish", flag: "🇵🇱", languageCode: "pl", ttsCode: "pl-PL"),
        LanguageModel(id: "Portugese (PT)", flag: "🇵🇹", languageCode: "pt-PT", ttsCode: "pt-PT"),
        LanguageModel(id: "Portugese (BR)", flag: "🇧🇷", languageCode: "pt-BR", ttsCode: "pt-BR"),
        LanguageModel(id: "Romanian", flag: "🇷🇴", languageCode: "ro", ttsCode: "ro-RO"),
        LanguageModel(id: "Russian", flag: "🇷🇺", languageCode: "ru", ttsCode: "ru-RU"),
        LanguageModel(id: "Slovak", flag: "🇸🇰", languageCode: "sk", ttsCode: "sk-SK"),
        LanguageModel(id: "Swedish", flag: "🇸🇪", languageCode: "sv", ttsCode: "sv-SE"),
        LanguageModel(id: "Turkish", flag: "🇹🇷", languageCode: "tr", ttsCode: "tr-TR"),
        LanguageModel(id: "Ukrainian", flag: "🇺🇦", languageCode: "uk", ttsCode: "uk-UA"),
        LanguageModel(id: "Chinese", flag: "🇨🇳", languageCode: "zh-CN", ttsCode: "zh-CN")
    ]
    
    var textToTranslate = ""
    var sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", languageCode: "en", ttsCode: "en-GB")
    var targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", languageCode: "it", ttsCode: "it-IT")
    var translation = ""
    
    var isLoadingTranslation = false
    
    
    //MARK: - API Call
    
    let headers = [
        "x-rapidapi-key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
        "x-rapidapi-host": "deep-translate6.p.rapidapi.com"
    ]
    
    func getTranslation(text: String, source: String, target: String) async {
        let headers = [
            "x-rapidapi-key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
            "x-rapidapi-host": "deep-translate6.p.rapidapi.com",
            "Content-Type": "application/json"
        ]
        let parameters = [
            "text": text,
            "source_language": source,
            "translate_language": target
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://deep-translate6.p.rapidapi.com/translate")! as URL,
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
            let text = decodedData.result
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


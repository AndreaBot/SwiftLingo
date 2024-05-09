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
    var translation = ""
    
    
    //MARK: - API Call
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            }
            if let safeData = data {
                if let translatedText = self.parseJSON(safeData) {
                    self.translation = translatedText
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
    
    //MARK: - UserDefaults (HistoryView)
    
    var userDef = UserDefaults.standard
    var history = [TranslationModel]()
    
    func appendToHistoryUserdefaults() {
        if let sourceLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == sourceLanguage.id
        }), let targetLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == targetLanguage.id
        }) {
            
            let newTranslation = TranslationModel(id: Date().timeIntervalSince1970, sourceLanguage: TranslatorViewModel.allLanguages[sourceLangIndex], targetLanguage: TranslatorViewModel.allLanguages[targetLangIndex], textToTranslate: textToTranslate, translation: translation)
            
            history.append(newTranslation)
            
            CheckUserDefaultsLimit()
            
            do {
                let data = try JSONEncoder().encode(history)
                
                userDef.set(data, forKey: "history")
            } catch {
                print("Error encoding")
            }
            
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
            do {
                let data = try JSONEncoder().encode(history)
                userDef.set(data, forKey: "history")
            } catch {
                print("Error encoding")
            }
            
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
    
    func setDefaultLanguages() {
        do {
            let sourceLanguageData = try JSONEncoder().encode(sourceLanguage)
            let targetLanguageData = try JSONEncoder().encode(targetLanguage)
            userDef.set(sourceLanguageData, forKey: "defaultSourceLanguage")
            userDef.set(targetLanguageData, forKey: "defaultTargetLanguage")
        } catch {
            print(error)
        }
    }
    
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
}


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
        LanguageModel(id: "Bulgarian", flag: "🇧🇬", sourceCode: "BG", targetCode: "BG", ttsCode: "bg-BG", ttsGender: "FEMALE", ttsVoice: "bg-BG-Standard-A"),
        LanguageModel(id: "Czech", flag: "🇨🇿", sourceCode: "CS", targetCode: "CS", ttsCode: "cs-CZ", ttsGender: "FEMALE", ttsVoice: "cs-CZ-Standard-A"),
        LanguageModel(id: "Danish", flag: "🇩🇰", sourceCode: "DA", targetCode: "DA", ttsCode: "da-DK", ttsGender: "FEMALE", ttsVoice: "da-DK-Standard-E"),
        LanguageModel(id: "German", flag: "🇩🇪", sourceCode: "DE", targetCode: "DE", ttsCode: "de-DE", ttsGender: "FEMALE", ttsVoice: "de-DE-Standard-C"),
        LanguageModel(id: "Greek", flag: "🇬🇷", sourceCode: "EL", targetCode: "EL", ttsCode: "el-GR", ttsGender: "FEMALE", ttsVoice: "el-GR-Standard-A"),
        LanguageModel(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB", ttsGender: "FEMALE", ttsVoice: "en-GB-Standard-C"),
        LanguageModel(id: "Spanish", flag: "🇪🇸", sourceCode: "ES", targetCode: "ES", ttsCode: "es-ES", ttsGender: "FEMALE", ttsVoice: "es-ES-Standard-C"),
        LanguageModel(id: "Finnish", flag: "🇫🇮", sourceCode: "FI", targetCode: "FI", ttsCode: "fi-FI", ttsGender: "FEMALE", ttsVoice: "fi-FI-Standard-A"),
        LanguageModel(id: "French", flag: "🇫🇷", sourceCode: "FR", targetCode: "FR", ttsCode: "fr-FR", ttsGender: "FEMALE", ttsVoice: "fr-FR-Neural2-C"),
        LanguageModel(id: "Hungarian", flag: "🇭🇺", sourceCode: "HU", targetCode: "HU", ttsCode: "hu-HU", ttsGender: "FEMALE", ttsVoice: "hu-HU-Standard-A"),
        LanguageModel(id: "Indonesian", flag: "🇮🇩", sourceCode: "ID", targetCode: "ID", ttsCode: "id-ID", ttsGender: "FEMALE", ttsVoice: "id-ID-Standard-A"),
        LanguageModel(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT", ttsGender: "FEMALE", ttsVoice: "it-IT-Standard-A"),
        LanguageModel(id: "Japanese", flag: "🇯🇵", sourceCode: "JA", targetCode: "JA", ttsCode: "ja-JP", ttsGender: "FEMALE", ttsVoice: "ja-JP-Standard-A"),
        LanguageModel(id: "Korean", flag: "🇰🇷", sourceCode: "KO", targetCode: "KO", ttsCode: "ko-KR", ttsGender: "FEMALE", ttsVoice: "ko-KR-Standard-A"),
        LanguageModel(id: "Lithuanian", flag: "🇱🇹", sourceCode: "LT", targetCode: "LT", ttsCode: "lt-LT", ttsGender: "MALE", ttsVoice: "lt-LT-Standard-A"),
        LanguageModel(id: "Latvian", flag: "🇱🇻", sourceCode: "LV", targetCode: "LV", ttsCode: "lv-LV", ttsGender: "MALE", ttsVoice: "lv-LV-Standard-A"),
        LanguageModel(id: "Norwegian", flag: "🇳🇴", sourceCode: "NB", targetCode: "NB", ttsCode: "nb-NO", ttsGender: "FEMALE", ttsVoice: "nb-NO-Standard-A"),
        LanguageModel(id: "Dutch", flag: "🇳🇱", sourceCode: "NL", targetCode: "NL", ttsCode: "nl-NL", ttsGender: "FEMALE", ttsVoice: "nl-NL-Standard-A"),
        LanguageModel(id: "Polish", flag: "🇵🇱", sourceCode: "PL", targetCode: "PL", ttsCode: "pl-PL", ttsGender: "FEMALE", ttsVoice: "pl-PL-Standard-A"),
        LanguageModel(id: "Portugese (PT)", flag: "🇵🇹", sourceCode: "PT", targetCode: "PT-PT", ttsCode: "pt-PT", ttsGender: "FEMALE", ttsVoice: "pt-PT-Standard-A"),
        LanguageModel(id: "Portugese (BR)", flag: "🇧🇷", sourceCode: "PT", targetCode: "PT-BR", ttsCode: "pt-BR", ttsGender: "FEMALE", ttsVoice: "pt-BR-Standard-A"),
        LanguageModel(id: "Romanian", flag: "🇷🇴", sourceCode: "RO", targetCode: "RO", ttsCode: "ro-RO", ttsGender: "FEMALE", ttsVoice: "ro-RO-Standard-A"),
        LanguageModel(id: "Russian", flag: "🇷🇺", sourceCode: "RU", targetCode: "RU", ttsCode: "ru-RU", ttsGender: "FEMALE", ttsVoice: "ru-RU-Standard-A"),
        LanguageModel(id: "Slovak", flag: "🇸🇰", sourceCode: "SK", targetCode: "SK", ttsCode: "sk-SK", ttsGender: "FEMALE", ttsVoice: "sk-SK-Standard-A"),
        LanguageModel(id: "Swedish", flag: "🇸🇪", sourceCode: "SV", targetCode: "SV", ttsCode: "sv-SE", ttsGender: "FEMALE", ttsVoice: "sv-SE-Standard-A"),
        LanguageModel(id: "Turkish", flag: "🇹🇷", sourceCode: "TR", targetCode: "TR", ttsCode: "tr-TR", ttsGender: "FEMALE", ttsVoice: "tr-TR-Standard-A"),
        LanguageModel(id: "Ukrainian", flag: "🇺🇦", sourceCode: "UK", targetCode: "UK", ttsCode: "uk-UA", ttsGender: "FEMALE", ttsVoice: "uk-UA-Standard-A"),
        LanguageModel(id: "Chinese", flag: "🇨🇳", sourceCode: "ZH", targetCode: "ZH", ttsCode: "cmn-CN", ttsGender: "FEMALE", ttsVoice: "cmn-CN-Standard-A")
    ]
    
    var textToTranslate = ""
    var sourceLanguage: LanguageModel = .init(id: "English", flag: "🇬🇧", sourceCode: "EN", targetCode: "EN-GB", ttsCode: "en-GB", ttsGender: "FEMALE", ttsVoice: "en-GB-Standard-C")
    var targetLanguage: LanguageModel = .init(id: "Italian", flag: "🇮🇹", sourceCode: "IT", targetCode: "IT", ttsCode: "it-IT", ttsGender: "FEMALE", ttsVoice: "it-IT-Standard-A")
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
                    self.appendToUserdefaults()
                    
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
    
    func appendToUserdefaults() {
        
        if let sourceLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == sourceLanguage.id
        }), let targetLangIndex = TranslatorViewModel.allLanguages.firstIndex(where: { languageModel in
            languageModel.id == targetLanguage.id
        }) {
            
            let newTranslation = TranslationModel(id: Date().timeIntervalSince1970, sourceLanguage: TranslatorViewModel.allLanguages[sourceLangIndex], targetLanguage: TranslatorViewModel.allLanguages[targetLangIndex], textToTranslate: textToTranslate, translation: translation)
            
            history.append(newTranslation)
            
            do {
                let data = try JSONEncoder().encode(history)
                
                userDef.set(data, forKey: "history")
            } catch {
                print("Error encoding")
            }
            
        }
    }
    
    func loadUserDefaults() {
        if let data = userDef.data(forKey: "history") {
            do {
                history = try JSONDecoder().decode([TranslationModel].self, from: data)
            } catch {
                print("error decoding")
            }
        }
    }
}

//
//  TTSViewModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 04/05/2024.
//

import Foundation
import AVFoundation

@Observable
final class TTSViewModel {
    
    var player = AVAudioPlayer()
    
    let headers = [
        "content-type": "application/json",
        "X-RapidAPI-Key": "38fde48a4dmsh982cb7ed015ff93p1529c1jsned543da8ef7a",
        "X-RapidAPI-Host": "joj-text-to-speech.p.rapidapi.com"
    ]
    
    func generateVoice(text: String, languageCode: String, name: String, ssmlGender: String) async {
        
        let parameters = [
            "input": ["text": text],
            "voice": [
                "languageCode": languageCode,
                "name": name,
                "ssmlGender": ssmlGender
            ],
            "audioConfig": ["audioEncoding": "MP3"]
        ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://joj-text-to-speech.p.rapidapi.com/")! as URL,
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
                let base64String = self.parseJSON(safeData)!
                self.playAudio(base64String)
            }
        })
        dataTask.resume()
    }
    
    
    func parseJSON(_ readData: Data) -> String? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpeechData.self, from: readData)
            let voice = decodedData.audioContent
            return voice
            
        } catch {
            print(error)
            return nil
        }
    }
    
    func playAudio(_ base64String: String) {
        
        guard let audioData = Data(base64Encoded: base64String) else {
            return
        }
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("audio.mp3")
        
        do {
            try audioData.write(to: fileURL)
            player = try AVAudioPlayer(contentsOf: fileURL)
            player.play()
            
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

//
//  TTSViewModel.swift
//  SwiftLingo
//
//  Created by Andrea Bottino on 04/05/2024.
//

import Foundation
import AVFoundation

@Observable
final class TTSViewModel: NSObject, AVSpeechSynthesizerDelegate {
    
    override init() {
        super.init()
        self.synth.delegate = self
    }
    
    let synth = AVSpeechSynthesizer()
    var isSpeaking = false
    var isSpeakingSlow = false
    
    
    func readTranslation(text: String, language: String, speed: Float) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = speed
        utterance.pitchMultiplier = 1.2
        if speed == 0.5 {
            isSpeaking = true
        } else {
            isSpeakingSlow = true
        }
        synth.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        isSpeakingSlow = false
    }
}

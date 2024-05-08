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
    
    let synth = AVSpeechSynthesizer()

    func readTranslation(text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.4
        utterance.pitchMultiplier = 1.2
        synth.speak(utterance)
    }
}

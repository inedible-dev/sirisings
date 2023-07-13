//
//  SpeechSynthesizer.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 4/4/23.
//

import AVFAudio

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    
    var synth = AVSpeechSynthesizer()
    
    @Published var lyricsFinishCount = 0 
    
    func initSpeech() {
        synth = AVSpeechSynthesizer()
        synth.delegate = self
    }
    
    func speak(_ lyric: String, rate: Float?, pitch: Float?, volume: Float?, preDelay: Float?) {
        let utterance = AVSpeechUtterance(string: lyric)
        
        if rate != nil {
            utterance.rate = rate!
        }
        if pitch != nil {
            utterance.pitchMultiplier = pitch!
        }
        if volume != nil {
            utterance.volume = volume! / 100
        }
        if preDelay != nil || preDelay != 0 {
            utterance.preUtteranceDelay = Double(preDelay!)
        }
        
        let voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.voice = voice
        
        synth.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        lyricsFinishCount += 1
    }
}

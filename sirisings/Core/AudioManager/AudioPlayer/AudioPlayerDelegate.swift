//
//  AudioPlayerDelegate.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 17/4/23.
//

import AVFAudio

class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate, ObservableObject {
    
    var player = AVAudioPlayer()
    
    @Published var finishedPlaying = false

    func initAudio(url: URL) -> Bool {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            return true
        } catch {
            return false
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        finishedPlaying = true
    }
}

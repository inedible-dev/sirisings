//
//  AudioManager.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 17/4/23.
//

import Combine
import AVFAudio

class AudioManager: ObservableObject {
    @Published var speechSynthesizer = SpeechSynthesizer()
    @Published var audioPlayer = AudioPlayerDelegate()
    
    @Published var isCuePressed = false
    @Published var isEditingInstrumental = false
    @Published var isPaused = true
    @Published var isChangingBlock = false
    @Published var noLyrics = false
    @Published var previewWithBackingMode = false
    @Published var volume: Float = 100
    @Published var audioFileName = ""
    
    var anyCancellableSS: AnyCancellable? = nil
    var anyCancellableAP: AnyCancellable? = nil
    
    init() {
        anyCancellableSS = speechSynthesizer.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
        anyCancellableAP = audioPlayer.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func rewindAndPlay(data: [LyricsBlock], selectedBlock: LyricsBlock?, selectedBlockIndex: Int?, assignFirstID: @escaping () -> Void) {
        rewindPlayback()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.handleInitialPlayback(data: data, selectedBlock: selectedBlock, selectedBlockIndex: selectedBlockIndex, assignFirstID: assignFirstID)
        }
    }
    
    func rewindPlayback() {
        isPaused = true
        audioPlayer.player.stop()
        audioPlayer.player.currentTime = 0
        speechSynthesizer.lyricsFinishCount = 0
        speechSynthesizer.synth.stopSpeaking(at: .immediate)
    }
    
    func handlePlaybackActions(data: [LyricsBlock], selectedBlock: LyricsBlock?, selectedBlockIndex: Int?, assignFirstID: @escaping () -> Void) {
        isCuePressed = false
        
        if selectedBlock?.lyric != nil {
            if speechSynthesizer.synth.isPaused || (!audioPlayer.player.isPlaying && audioPlayer.player.currentTime != 0) {
                resumePlayback()
            } else if speechSynthesizer.synth.isSpeaking || audioPlayer.player.isPlaying {
                pausePlayback()
            } else {
                handleInitialPlayback(data: data, selectedBlock: selectedBlock, selectedBlockIndex: selectedBlockIndex, assignFirstID: assignFirstID)
            }
        } else {
            noLyrics.toggle()
        }
    }
    
    private func resumePlayback() {
        isPaused = false
        if previewWithBackingMode && !audioPlayer.player.isPlaying && audioPlayer.player.currentTime != 0 {
            audioPlayer.player.play()
        }
        speechSynthesizer.synth.continueSpeaking()
    }
    
    private func pausePlayback() {
        isPaused = true
        if previewWithBackingMode {
            audioPlayer.player.pause()
        }
        speechSynthesizer.synth.pauseSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    private func handleInitialPlayback(data: [LyricsBlock], selectedBlock: LyricsBlock?, selectedBlockIndex: Int?, assignFirstID: @escaping () -> Void) {
        if !isSingleUnavailableLyric(data: data, selectedBlockLyrics: selectedBlock?.lyric) && selectedBlockIndex != nil {
            
            speechSynthesizer.initSpeech()
            
            isPaused = false
            if previewWithBackingMode {
                assignFirstID()
                audioPlayer.player.play()
                audioPlayer.finishedPlaying = false
            }
            synthesizeLyrics(data: data, selectedBlockIndex: selectedBlockIndex!)
        } else {
            noLyrics.toggle()
        }
    }
    
    private func isSingleUnavailableLyric(data: [LyricsBlock], selectedBlockLyrics: String?) -> Bool {
        return data.count == 1 && selectedBlockLyrics == "No lyrics available"
    }
    
    private func synthesizeLyrics(data: [LyricsBlock], selectedBlockIndex: Int) {
        for lyric in previewWithBackingMode ? data : Array(data.suffix(from: selectedBlockIndex)) {
            speechSynthesizer.speak(lyric.lyric, rate: lyric.rate, pitch: lyric.pitch, volume: lyric.volume, preDelay: lyric.preDelay)
        }
    }
    
    func handleHoldActionForPreview(data: [LyricsBlock], selectedBlock: LyricsBlock?) {
        if previewWithBackingMode { return }
        if isSingleUnavailableLyric(data: data, selectedBlockLyrics: selectedBlock?.lyric) {
            noLyrics.toggle()
        } else {
            isCuePressed = true
            
            rewindPlayback()
            speechSynthesizer.initSpeech()
            
            guard let selectedData = selectedBlock else { return }
            speechSynthesizer.speak(selectedData.lyric, rate: selectedData.rate, pitch: selectedData.pitch, volume: selectedData.volume, preDelay: 0)
        }
    }
}

//
//  AudioSheetView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import SwiftUI
import AVFAudio

struct AudioSheetView: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var audioManager: AudioManager
    
    @Environment(\.dismiss) var dismissView
    
    @State private var isImporting = false
    @State private var failedImporting = false
    
    var body: some View {
        VStack {
            NavbarView(rightAction: { dismissView() })
            VStack {
                Text("Preview with Backing Track")
                    .font(.title.bold())
                Text("To start playing, please import your audio file")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                VStack(spacing: 36) {
                    HStack(spacing: 16) {
                        Text("Current Audio File")
                            .font(.title2.weight(.semibold))
                        Spacer()
                        Text("\(audioManager.audioFileName.isEmpty ? "None" : audioManager.audioFileName)")
                        Button(action: {
                            isImporting.toggle()
                        }) {
                            Text("Import")
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(cornerRadius: 12, fill: .white)
                        }
                    }
                    VStack {
                        HStack {
                            Text("Volume")
                            Spacer()
                            Text("\(Int(audioManager.volume))")
                        }.font(.title2.weight(.semibold))
                        HStack {
                            Text("0")
                                .frame(width: 30)
                            Slider(value: $audioManager.volume, in: 0...100, step: 1)
                                .onChange(of: audioManager.volume) { vol in
                                    if audioManager.audioPlayer.player.url != nil {
                                        audioManager.audioPlayer.player.volume = vol / 100
                                    }
                                }
                            Text("100")
                                .frame(width: 30)
                            Button(action: {
                                audioManager.volume = 100
                            }) {
                                Image(systemName: "arrow.clockwise.circle.fill")
                            }.foregroundColor(audioManager.volume == 100 ? .gray : .white).disabled(audioManager.volume == 100)
                        }
                    }
                }.padding(.vertical, 30)
                Spacer()
                let check = audioManager.audioPlayer.player.url == nil || (manager.data.count == 1 && manager.getDataFromSelectedID()?.lyric == "No lyrics available")
                Button(action: {
                    if manager.data.count == 1 && manager.getDataFromSelectedID()?.lyric == "No lyrics available" {
                    } else {
                        dismissView()
                        if audioManager.speechSynthesizer.synth.isSpeaking {
                            audioManager.rewindPlayback()
                        }
                        audioManager.previewWithBackingMode.toggle()
                    }
                }) {
                    Text(audioManager.previewWithBackingMode ? "Stop Previewing" : "Preview")
                        .font(.body.weight(.semibold))
                        .frame(maxWidth: 700)
                        .padding(.vertical, 12)
                        .background(cornerRadius: 12, fill: check ? Color.init(white: 0.4) : Color("BrightPurple"))
                }.buttonStyle(ScaleButtonStyle())
                    .alert(isPresented: $audioManager.noLyrics) {
                        Alert(title: Text("No lyrics Provided"), message: Text("Please type in the lyrics before proceeding"))
                    }
                    .disabled(check)
            }.padding()
                .fileImporter(isPresented: $isImporting, allowedContentTypes: [.audio]) { result in
                    if audioManager.previewWithBackingMode {
                        audioManager.isPaused = true
                        manager.selectedID = manager.data.first?.id
                        audioManager.audioPlayer.player.stop()
                        audioManager.audioPlayer.player.currentTime = 0
                        audioManager.speechSynthesizer.synth.stopSpeaking(at: .immediate)
                    }
                    do {
                        let fileURL = try result.get()
                        
                        guard fileURL.startAccessingSecurityScopedResource() else { return }
                        
                        if !audioManager.audioPlayer.initAudio(url: fileURL) {
                            failedImporting.toggle()
                        }
                        
                        audioManager.audioPlayer.player.volume = audioManager.volume / 100
                        
                        audioManager.audioFileName = fileURL.lastPathComponent
                        
                        fileURL.stopAccessingSecurityScopedResource()
                    } catch {
                        failedImporting.toggle()
                    }
                }.alert(isPresented: $failedImporting) {
                    Alert(title: Text("Failed to Import"), message: Text("Failed to import the Audio File"))
                }
        }
    }
}

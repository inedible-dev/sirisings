//
//  SidebarView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var audioManager: AudioManager
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var dismissView: () -> Void
    
    @Binding var isExporting: Bool
    @Binding var fileName: String
    
    @State private var isSaving = false
    @State private var isResetting = false
    @State private var isEditingInstrumental = false
    
    var body: some View {
        let compact = sizeClass == .compact /// Check if is in compact mode
        
        AdaptiveStack(smallStack: .hStack, spacing: compact ? 8 : 20) {
            ImageButton(systemName: "house.fill") {
                dismissView()
                audioManager.rewindPlayback()
            }.padding(compact ? 0 : 10)
            ImageButton(systemName: "square.and.arrow.down.fill") {
                isSaving.toggle()
            }.sheet(isPresented: $isSaving) {
                ExportSheetView(isExporting: $isExporting, fileName: $fileName)
            }
            ImageButton(systemName: "xmark.app.fill") {
                isResetting.toggle()
            }.alert(isPresented: $isResetting) {
                Alert(title: Text("Delete Current Session"), message: Text("Press Delete to delete the current Session"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")){
                    dismissView()
                    manager.deleteLastSession()
                })
            }
            ImageButton(systemName: "waveform.circle.fill") {
                isEditingInstrumental.toggle()
            }.sheet(isPresented: $isEditingInstrumental) {
                AudioSheetView()
            }
            Spacer()
            CircleButton(view: .pre, color: "PreOrange")
            CircleButton(view: .play, color: "PlayGreen")
                .alert(isPresented: $audioManager.noLyrics) {
                    Alert(title: Text("The selected block has no lyrics"))
                }
        }.padding(.vertical, 10)
            .padding(.horizontal, compact ? 10 : 28)
            .background(Color.init(white: 0.17))
            .onChange(of: audioManager.speechSynthesizer.lyricsFinishCount) { _ in
                if !audioManager.isCuePressed && !audioManager.isPaused {
                    if !manager.pushSelectedID() {
                        if !audioManager.previewWithBackingMode || audioManager.audioPlayer.player.currentTime == 0 {
                            manager.selectedID = manager.data.first?.id
                            audioManager.rewindPlayback()
                        }
                    }
                }
            }
            .onChange(of: audioManager.audioPlayer.finishedPlaying) { finished in
                if !audioManager.speechSynthesizer.synth.isSpeaking && audioManager.audioPlayer.finishedPlaying {
                    audioManager.isPaused = true
                }
            }
    }
}

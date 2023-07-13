//
//  CircleButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 31/3/23.
//

import SwiftUI
import AVFAudio

struct CircleButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var audioManager: AudioManager
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    enum ViewType {
        case pre, play
    }
    
    var view: ViewType
    var color: String
    
    func circleButtonAction() {
        switch view {
        case .pre:
            if audioManager.previewWithBackingMode {
                manager.selectedID = manager.data.first?.id
            }
            audioManager.rewindPlayback()
        case .play:
            audioManager.handlePlaybackActions(data: manager.data, selectedBlock: manager.getDataFromSelectedID(), selectedBlockIndex: manager.getIndexFromSelectedID(), assignFirstID: {
                manager.assignFirstSelectedID()
            })
        }
    }
    
    func circleButtonActionHold() {
        if view == .pre {
            audioManager.handleHoldActionForPreview(data: manager.data, selectedBlock: manager.getDataFromSelectedID())
        }
    }
    
    var body: some View {
        
        let compact = sizeClass == .compact /// Check if is in compact mode
        
        Button(action: {
            circleButtonAction()
        }) {
            switch view {
            case .pre:
                if audioManager.previewWithBackingMode {
                    Image(systemName: "arrow.up")
                        .font(compact ? .headline.bold() : .title2.bold())
                } else {
                    Text("PRE")
                }
            case .play:
                Image(systemName: "playpause.fill")
            }
        }.buttonStyle(CircleButtonStyle(color: color, isPlaying: view == .play && (audioManager.isChangingBlock || !audioManager.isPaused)))
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0).onEnded({ _ in
                    circleButtonActionHold()
                }))
    }
}

struct CircleButtonStyle: ButtonStyle {
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    var color: String
    var isPlaying: Bool
    
    func makeBody(configuration: Self.Configuration) -> some View {
        let compact = sizeClass == .compact
        let pressed = configuration.isPressed || isPlaying
        
        let frameSize: CGFloat = compact ? 60 : 100
        
        configuration.label
            .frame(width: frameSize, height: frameSize)
            .background(
                ZStack {
                    Circle()
                        .fillAngularGradientShade()
                        .blur(radius: 5)
                    Circle()
                        .fill(.black)
                        .opacity(pressed ? 0.85 : 0.25)
                    Circle()
                        .strokeAngular(pressed ? 3 : 6)
                    Circle()
                        .strokeBorder(Color.init(color), lineWidth: 3)
                }.clipShape(Circle()))
            .foregroundColor(Color.init(white: pressed ? 0.4 : 0.9))
            .font(compact ? .caption.bold() : .headline.bold())
            .minimumScaleFactor(0.1)
    }
}

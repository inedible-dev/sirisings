//
//  LyricsStack.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct LyricsStack<Content: View>: View  {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var audioManager: AudioManager
    @EnvironmentObject var viewManager: ViewManager
    
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    var content: () -> Content
    
    var body: some View {
        let compact = sizeClass == .compact /// Check if is in compact mode
        
        AdaptiveStack {
            Spacer()
            ScrollViewIfNeeded(showsIndicators: false) {
                VStack(content: content)
                    .padding(.vertical, compact ? 50 : 100)
            }.mask(LinearGradient(.maskTopBottom(values: (
                topPosition: viewManager.stackPosition == .top ? 0 : 0.1,
                bottomPosition: viewManager.stackPosition == .bottom ? 1 : 0.9)))
            ).frame(maxWidth: audioManager.previewWithBackingMode ? 700 : nil)
            Spacer()
        }
    }
}


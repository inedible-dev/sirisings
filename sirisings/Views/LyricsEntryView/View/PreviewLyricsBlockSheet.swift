//
//  PreviewLyricsBlockSheet.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import SwiftUI

struct PreviewLyricsBlockSheet: View {
    
    @Environment(\.dismiss) var dismissView
    
    @Binding var previewBlocks: [LyricsBlock]
    
    var body: some View {
        VStack {
            NavbarView(rightAction: { dismissView() })
            ScrollViewIfNeeded {
                ForEach(previewBlocks) {lyricBlock in
                    PreviewLyricsBlockView(lyric: lyricBlock.lyric)
                }
            }.padding(20)
            Spacer()
        }
    }
}

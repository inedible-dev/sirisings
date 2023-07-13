//
//  LyricsEntryView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 11/4/23.
//

import SwiftUI

struct LyricsEntryView: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var viewManager: ViewManager
    
    @Environment(\.dismiss) var dismissView
    
    @State private var lyrics = ""
    @State private var noLyrics = false
    @State private var showPreview = false
    @State private var previewBlocks: [LyricsBlock] = LyricsManager.defaultBlock
    
    var body: some View {
        ZStack {
            LinearGradient(.siriSingsBGR).edgesIgnoringSafeArea(.all).onTapGesture {
                self.hideKeyboard()
            }
            VStack {
                NavbarView(rightTitle: "Preview", leftAction: { dismissView() }, rightAction: {
                    hideKeyboard()
                    let trimmed = lyrics.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        previewBlocks = manager.previewLyricsBlock(lyrics: trimmed)
                    } else {
                        previewBlocks = LyricsManager.defaultBlock
                    }
                    showPreview.toggle()
                })
                Spacer()
                VStack {
                    Text("Enter your Lyrics")
                        .font(.largeTitle.bold())
                    Text("To separate Lyric Blocks, break line by pressing the return key")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    LyricsTextEditor(lyrics: $lyrics)
                    Button(action: {
                        let trim = lyrics.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trim.isEmpty {
                            dismissView()
                            manager.convertToLyricsBlock(lyrics: trim)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewManager.isShowingSpeechEditor.toggle()
                            }
                        } else { noLyrics.toggle() }
                    }) {
                        Text("Done")
                            .frame(maxWidth: 700)
                            .padding(.vertical, 12)
                            .background(cornerRadius: 12, fill: Color("DarkPurple"))
                    }.buttonStyle(ScaleButtonStyle())
                        .alert(isPresented: $noLyrics) {
                            Alert(title: Text("No lyrics Provided"), message: Text("Please type in the lyrics before proceeding"))
                        }
                    Text("Warning: There will be around half-second delay between lyric blocks")
                        .foregroundColor(.init(white: 0.7))
                        .multilineTextAlignment(.center)
                }.padding()
                Spacer()
            }
        }.sheet(isPresented: $showPreview) {
            PreviewLyricsBlockSheet(previewBlocks: $previewBlocks)
        }
    }
}

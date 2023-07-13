//
//  LyricsSelector.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 30/3/23.
//

import SwiftUI

struct LyricsButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var audioManager: AudioManager
    
    @FocusState private var focusTextField: Bool
    
    @Binding var data: LyricsBlock
    
    var scrollAction: () -> Void
    
    @State private var noLyric = false
    
    func checkEmpty() -> Bool {
        return data.lyric.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 3) {
            if data.preDelay > 0 {
                HStack {
                    Rectangle()
                        .fill(Color.init(white: 0.3))
                        .frame(height: 1)
                    Spacer()
                    Text("\(String(format: "%.1f", data.preDelay)) second\(data.preDelay > 2 ? "s" : "")")
                        .frame(minWidth: 120)
                    Spacer()
                    Rectangle()
                        .fill(Color.init(white: 0.3))
                        .frame(height: 1)
                }
            }
            if !data.isFocused {
                Button(action: {
                    manager.selectedID = data.id
                    if audioManager.isPaused {
                        audioManager.rewindPlayback()
                    } else {
                        audioManager.isChangingBlock = true
                        audioManager.rewindAndPlay(data: manager.data, selectedBlock: manager.getDataFromSelectedID(), selectedBlockIndex: manager.getIndexFromSelectedID(), assignFirstID: {
                            manager.assignFirstSelectedID()
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            audioManager.isChangingBlock = false
                        }
                    }
                }) {
                    HStack {
                        Text(data.lyric)
                        Spacer()
                    }.frame(alignment: .leading)
                        .padding(20)
                        .background(manager.selectedID == data.id ? Color.gray : Color.init(white: 0.2))
                        .cornerRadius(18)
                        .font(.title.weight(.semibold))
                        .foregroundColor(Color.white)
                }.buttonStyle(ScaleButtonStyle(changeOpacity: true))
                    .disabled(manager.getDataFromSelectedID()!.isFocused || audioManager.previewWithBackingMode)
            } else {
                HStack {
                    TextField("Enter Lyrics Here", text: $data.lyric, onEditingChanged: { (editingChanged) in
                        if !editingChanged {
                            if checkEmpty() {
                                noLyric = true
                            } else {
                                data.isFocused.toggle()
                                manager.lastLyric = ""
                            }
                        }
                    }).focused($focusTextField)
                        .font(.title.weight(.semibold))
                        .background(manager.selectedID == data.id ? Color.gray : Color.init(white: 0.2))
                    Button("Done") {
                        if checkEmpty() {
                            noLyric = true
                        } else {
                            data.isFocused.toggle()
                        }
                    }.padding(6)
                        .font(.title3.weight(.semibold))
                }.padding(20)
                    .background(manager.selectedID == data.id ? Color.gray : Color.init(white: 0.2))
                    .cornerRadius(18)
                    .font(.title.weight(.semibold))
                    .foregroundColor(Color.white)
            }
        }.id(data.id)
            .alert(isPresented: $noLyric) {
                Alert(title: Text("Delete Current Block"), message: Text("Press cancel to restore the Previous Lyric"), primaryButton: .cancel() {
                    data.lyric = manager.lastLyric
                    data.isFocused = true
                }, secondaryButton: .destructive(Text("Delete")){
                    manager.deleteLyricBlock(id: data.id)
                    manager.lastLyric = ""
                })
            }
            .onAppear {
                self.focusTextField = data.isFocused
            }
            .onChange(of: focusTextField) {
                data.isFocused = $0
            }
            .onChange(of: data.isFocused) {
                focusTextField = $0
            }
    }
}

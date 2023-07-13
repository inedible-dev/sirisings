import SwiftUI
import AVFAudio

let isIpad = UIDevice.current.userInterfaceIdiom == .pad

struct LyricsView: View {
    
    @EnvironmentObject var manager: LyricsManager
    @StateObject var audioManager = AudioManager()
    
    @Environment(\.dismiss) var dismissView
    
    @State private var isExporting = false
    @State private var fileName = ""
    @State private var isiOSEditing = false
    @State private var currentParamSelected: BlockAdjustParams = .volume
    
    func checkiOSParam(_ param: BlockAdjustParams) -> Bool {
        if isIpad || (!isIpad && currentParamSelected == param) { return true }
        return false
    }
    
    var body: some View {
        ZStack {
            Color.init(white: 0.03).edgesIgnoringSafeArea(.all)
            AdaptiveStack {
                SidebarView(dismissView: { dismissView() }, isExporting: $isExporting, fileName: $fileName)
                AdaptiveStack(checkPortrait: true, spacing: 30) {
                    VStack {
                        LyricsStack {
                            ScrollViewReader { reader in
                                ForEach($manager.data) {$lyrics in
                                    LyricsButton(data: $lyrics, scrollAction: { reader.scrollTo(lyrics.id) })
                                }.onChange(of: manager.selectedID) { id in
                                    withAnimation(.easeIn) {
                                        reader.scrollTo(id, anchor: .center)
                                    }
                                }
                            }
                        }
                        if audioManager.previewWithBackingMode {
                            Button(action: {
                                audioManager.previewWithBackingMode.toggle()
                                if audioManager.speechSynthesizer.synth.isSpeaking {
                                    audioManager.rewindPlayback()
                                }
                            }) {
                                Text("Stop Previewing")
                                    .font(.body.weight(.semibold))
                                    .frame(maxWidth: 700)
                                    .padding(.vertical, 12)
                                    .background(cornerRadius: 12, fill: Color("BrightPurple"))
                            }.buttonStyle(ScaleButtonStyle())
                        }
                    }
                    VStack {
                        if !audioManager.previewWithBackingMode && manager.checkSelectedIDExists()  {
                            if (isIpad || isiOSEditing) && manager.checkLastSession() {
                                VStack(spacing: 30) {
                                    if checkiOSParam(.volume) {
                                        LyricsUtteranceSlider("Volume", utteranceVariable: .volume, range: 0...100, step: 1, valueFormat: "%.0f", defaultValue: 100)
                                    }
                                    if checkiOSParam(.pitch) {
                                        LyricsUtteranceSlider("Pitch", utteranceVariable: .pitch, range: 0.5...2, valueFormat: "%.2f", defaultValue: 1)
                                    }
                                    if checkiOSParam(.rate) {
                                        LyricsUtteranceSlider("Rate", utteranceVariable: .rate, range: AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate, valueFormat: "%.2f", defaultValue: 0.5)
                                    }
                                    if checkiOSParam(.preDelay) {
                                        LyricsPreUtteranceStepper()
                                    }
                                }.padding(20).background(cornerRadius: 18, fill: .init(white: 0.1))
                                if !isIpad {
                                    VStack {
                                        HStack(spacing: 5) {
                                            BlockParamButton(param: .volume, selectedParam: $currentParamSelected)
                                            BlockParamButton(param: .pitch, selectedParam: $currentParamSelected)
                                            BlockParamButton(param: .rate, selectedParam: $currentParamSelected)
                                            BlockParamButton(param: .preDelay, selectedParam: $currentParamSelected)
                                        }.background(cornerRadius: 12, fill: .init(white: 0.2))
                                        Button(action: {
                                            isiOSEditing = false
                                        }) {
                                            Text("Done")
                                                .font(.body.weight(.semibold))
                                                .frame(maxWidth: 700)
                                                .padding(.vertical, 12)
                                                .background(cornerRadius: 12, fill: Color("BrightPurple"))
                                        }
                                    }
                                }
                            }
                            VStack {
                                if !isiOSEditing {
                                    HStack {
                                        VStack {
                                            HStack {
                                                BlockManagerButton(actions: .addBefore)
                                                BlockManagerButton(actions: .addAfter)
                                            }
                                            HStack {
                                                BlockManagerButton(actions: .edit)
                                                BlockManagerButton(actions: .delete)
                                            }
                                        }.padding(.vertical)
                                            .frame(maxWidth: .infinity)
                                        if !isIpad {
                                            Button(action: { isiOSEditing = true }) {
                                                Image(systemName: "slider.horizontal.3")
                                                    .font(.title)
                                                    .padding(4)
                                                    .frame(maxWidth: .infinity, maxHeight: 120)
                                                    .background(cornerRadius: 12, fill: .init(white: 0.3))
                                            }
                                        }
                                    }.frame(maxHeight: 120)
                                }
                            }
                        }
                    }
                }.padding(.horizontal, 20)
                    .padding(.bottom)
            }.fileExporter(isPresented: $isExporting, document: try? JSONDocument(manager.data, fileName: fileName), contentType: .json) { _ in }
                .environmentObject(audioManager)
        }
    }
}

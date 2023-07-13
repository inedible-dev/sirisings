//
//  GetStartedButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct GetStartedButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var viewManager: ViewManager
    
    @State private var isShowingLyricsEntry = false
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        Button(action: {
            isShowingLyricsEntry.toggle()
        }) {
            HStack {
                Text("Get Started")
                    .font(isIpad ? .body.weight(.semibold) : .system(size: 14, weight: .semibold))
                if !manager.checkLastSession() {
                    Spacer()
                    Image(systemName: "arrow.forward")
                }
            }.padding(14)
                .frame(maxWidth: 400)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(12)
                .minimumScaleFactor(0.5)
        }.buttonStyle(ScaleButtonStyle())
            .alert(isPresented: $viewManager.audioSessionInitFailed) {
                Alert(title: Text("Failed to Initialize Session"), message: Text("Failed to Initialize the AVAudioSession, please restart the Application"))
            }
            .fullScreenCover(isPresented: $isShowingLyricsEntry, content: LyricsEntryView.init)
    }
}

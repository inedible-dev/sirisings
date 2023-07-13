//
//  RestoreLastSessionButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 17/4/23.
//

import SwiftUI

struct RestoreLastSessionButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var viewManager: ViewManager
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        Button(action: {
            if let decoded = manager.json.decodeJSON(jsonData: manager.getLastSessionLyrics()!) {
                manager.data = decoded
                manager.selectedID = manager.getLastSessionSelectedID() ?? manager.data.first?.id
                viewManager.isShowingSpeechEditor.toggle()
            }
        }) {
            HStack {
                Text("Restore Session")
            }.font(isIpad ? .body.weight(.semibold) : .system(size: 14, weight: .semibold))
                .padding(14)
                .frame(maxWidth: 400)
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(12)
                .minimumScaleFactor(0.5)
        }.buttonStyle(ScaleButtonStyle())
            .fullScreenCover(isPresented: $viewManager.isShowingSpeechEditor, content: LyricsView.init)
    }
}

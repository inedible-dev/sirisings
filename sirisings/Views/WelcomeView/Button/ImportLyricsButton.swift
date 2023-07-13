//
//  ImportLyricsButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct ImportLyricsButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    @EnvironmentObject var viewManager: ViewManager
    
    @State private var isImporting = false
    @State private var failedImporting = false
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        Button(action: { isImporting.toggle() }) {
            HStack {
                Text("Import Lyrics")
                Spacer()
                Image(systemName: "square.and.arrow.down.fill")
            }.font(isIpad ? .body.weight(.semibold) : .system(size: 14, weight: .semibold))
                .padding(14)
                .frame(maxWidth: 400)
                .background(LinearGradient(.siriSingsBGR))
                .foregroundColor(.white)
                .cornerRadius(12)
        }.buttonStyle(ScaleButtonStyle())
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                do{
                    let fileURL = try result.get()
                    
                    guard fileURL.startAccessingSecurityScopedResource() else { return }
                    
                    if let jsonData = try? Data(contentsOf: fileURL) {
                        if let decoded = manager.json.decodeJSON(jsonData: jsonData) {
                            manager.data = decoded
                            manager.assignFirstSelectedID()
                            viewManager.isShowingSpeechEditor.toggle()
                        } else {
                            failedImporting.toggle()                        }
                    }
                    fileURL.stopAccessingSecurityScopedResource()
                } catch {
                    failedImporting.toggle()
                }
            }.alert(isPresented: $failedImporting) {
                Alert(title: Text("Failed to Import"), message: Text("Please check if your JSON File is exported by SiriSings App"))
            }
    }
}


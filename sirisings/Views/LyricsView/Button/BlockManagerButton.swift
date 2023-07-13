//
//  BlockManagerButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import SwiftUI

struct BlockManagerButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    
    enum Actions {
        case addBefore, addAfter, edit, delete
    }
    
    var actions: Actions
    
    var label: String
    var symbolName: String
    
    @State private var showDeleteAlert = false
    
    init(actions: Actions) {
        self.actions = actions
        
        switch actions {
        case .addBefore:
            self.symbolName = "arrow.up.to.line"
        case .addAfter:
            self.symbolName = "arrow.down.to.line"
        case .edit:
            self.symbolName = "square.and.pencil.circle.fill"
        case .delete:
            self.symbolName = "trash.fill"
        }
        
        switch actions {
        case .addBefore:
            self.label = "Add Track Before"
        case .addAfter:
            self.label = "Add Track After"
        case .edit:
            self.label = "Edit Track"
        case .delete:
            self.label = "Delete Track"
        }
    }
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        Button(action: {
            switch actions {
            case .addBefore:
                manager.addLyricBlock(.before)
            case .addAfter:
                manager.addLyricBlock(.after)
            case .edit:
                if let index = manager.getIndexFromSelectedID() {
                    manager.data[index].isFocused = true
                    manager.lastLyric = manager.data[index].lyric
                }
            case .delete:
                showDeleteAlert.toggle()
            }
        }) {
            HStack(spacing: 10) {
                Image(systemName: symbolName)
                    .font(actions == .edit ? .title : .title3)
                if isIpad {
                    Text(label)
                        .fontWeight(.semibold)
                }
            }.padding()
                .frame(maxWidth: 500, maxHeight: 55)
                .background(cornerRadius: 12, fill: .init(white: 0.3))
        }.foregroundColor(.white)
            .disabled(manager.getDataFromSelectedID()!.isFocused)
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Delete Current Block"), message: Text("Delete the current lyric block?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")){
                    manager.deleteLyricBlock(id: manager.selectedID!)
                })
            }
    }
}

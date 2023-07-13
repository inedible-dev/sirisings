//
//  ResetValueButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct ResetValueButton: View {
    
    @EnvironmentObject var manager: LyricsManager
    
    var utteranceVariable: LyricsBlock.GettableBlockValue
    var defaultValue: Float
    
    var body: some View {
        if let index = manager.getIndexFromSelectedID() {
            let checkDefault = manager.data[index].getValue(utteranceVariable) == defaultValue
            
            Button(action: {
                if let index = manager.getIndexFromSelectedID() {
                    manager.data[index].assignValue(utteranceVariable, value: defaultValue)
                }
            }) {
                Image(systemName: "arrow.clockwise.circle.fill")
            }.foregroundColor(checkDefault ? .gray : .white).disabled(checkDefault)
        }
    }
}

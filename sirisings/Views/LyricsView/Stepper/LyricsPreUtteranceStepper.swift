//
//  LyricsPreUtteranceStepper.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct LyricsPreUtteranceStepper: View {
    
    @EnvironmentObject var manager: LyricsManager
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Predelay")
                Spacer()
                Text("\(String(format: "%.1f", manager.getDataFromSelectedID()!.preDelay))")
            }.font(.title2.weight(.semibold))
            HStack {
                Stepper("", value: manager.getBinding(.preDelay), in: 0...300, step: 0.1)
                ResetValueButton(utteranceVariable: .preDelay, defaultValue: 0)
            }
        }
    }
}

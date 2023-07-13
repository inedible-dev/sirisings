//
//  LyricsUtteranceSlider.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct LyricsUtteranceSlider: View {
    
    @EnvironmentObject var manager: LyricsManager
    
    var label: String
    var utteranceVariable: LyricsBlock.GettableBlockValue
    var range: ClosedRange<Float>
    var step: Float
    var valueFormat: String
    var defaultValue: Float
    
    init(_ label: String, utteranceVariable: LyricsBlock.GettableBlockValue, range: ClosedRange<Float>, step: Float = 0.01, valueFormat: String = "%.2f", defaultValue: Float) {
        self.label = label
        self.utteranceVariable = utteranceVariable
        self.range = range
        self.step = step
        self.valueFormat = valueFormat
        self.defaultValue = defaultValue
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                Spacer()
                Text("\(String(format: valueFormat, manager.getDataFromSelectedID()!.getValue(utteranceVariable)))")
            }.font(.title2.weight(.semibold))
            HStack {
                Text("\(range.lowerBound.clean)")
                    .frame(width: 30)
                Slider(value: manager.getBinding(utteranceVariable), in: range, step: step)
                Text("\(range.upperBound.clean)")
                    .frame(width: 30)
                ResetValueButton(utteranceVariable: utteranceVariable, defaultValue: defaultValue)
            }
        }
    }
}

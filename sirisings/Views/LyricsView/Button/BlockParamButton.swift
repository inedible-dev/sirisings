//
//  BlockParamButton.swift
//  sirisings
//
//  Created by Wongkraiwich Chuenchomphu on 13/7/23.
//

import SwiftUI

enum BlockAdjustParams {
    case volume, pitch, rate, preDelay
}

struct BlockParamButton: View {
    var param: BlockAdjustParams
    
    @Binding var selectedParam: BlockAdjustParams
    
    func getIcon() -> String {
        switch param {
        case .volume:
            return "speaker.wave.1.fill"
        case .pitch:
            return "pianokeys.inverse"
        case .rate:
            return "arrow.left.and.right"
        case .preDelay:
            return "clock.arrow.circlepath"
        }
    }
    
    var body: some View {
        Button(action: {selectedParam = param}) {
            Image(systemName: getIcon())
                .font(.title3)
                .padding()
                .frame(maxWidth: 500, maxHeight: 55)
                .background(cornerRadius: 12, fill: .init(white: selectedParam == param ? 0.3 : 0.2))
        }
    }
}

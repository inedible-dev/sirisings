//
//  ScaleButtonStyle.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 12/4/23.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    var changeOpacity = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(changeOpacity && configuration.isPressed ? 0.8 : 1)
    }
}

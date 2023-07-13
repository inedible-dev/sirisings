//
//  Background+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 3/4/23.
//

import SwiftUI

struct BackgroundExtension: ViewModifier {
    
    var cornerRadius: CGFloat
    var fill: Color
    
    func body(content: Content) -> some View {
        content.background(
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: .continuous
            )
            .fill(fill)
        )
    }
}

extension View {
    func background(cornerRadius: CGFloat, fill: Color) -> some View {
        modifier(BackgroundExtension(cornerRadius: cornerRadius, fill: fill))
    }
}

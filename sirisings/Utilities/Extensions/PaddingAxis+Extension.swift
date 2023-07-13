//
//  PaddingAxis+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 1/4/23.
//

import SwiftUI

enum PaddingAxis {
    case horizontal, vertical
}

struct PaddingExtension: ViewModifier {
    
    var axis: PaddingAxis
    var length: CGFloat
    
    func body(content: Content) -> some View {
        switch axis {
        case .horizontal:
            content.padding(EdgeInsets(top: 0, leading: length, bottom: 0, trailing: length))
        case .vertical:
            content.padding(EdgeInsets(top: length, leading: 0, bottom: length, trailing: 0))
        }
    }
}

extension View {
    func padding(_ axis: PaddingAxis, _ length: CGFloat) -> some View {
        modifier(PaddingExtension(axis: axis, length: length))
    }
}

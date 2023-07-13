//
//  ViewLinearGradient+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 9/4/23.
//

import SwiftUI

extension LinearGradient {
    
    enum LinearGradientStyles {
        case siriSingsBGR, maskTopBottom(values: (topPosition: CGFloat,bottomPosition: CGFloat))
    }
    
    init(_ styles: LinearGradientStyles) {
        switch styles {
        case .siriSingsBGR:
            self.init(colors: [Color("Blue"), Color("Green"), Color("Red")], startPoint: .leading, endPoint: .trailing)
        case let .maskTopBottom(values: (topPosition, bottomPosition)):
            self.init(gradient: Gradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: topPosition),
                .init(color: .black, location: bottomPosition),
                .init(color: .clear, location: 1)
            ]), startPoint: .top, endPoint: .bottom)
        }
    }
}

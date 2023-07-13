//
//  ShapeAngularGradient+Extension.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 12/4/23.
//

import SwiftUI

extension Shape {
    public func fillAngularGradientShade() -> some View {
        self.fill(AngularGradient(stops: [
            Gradient.Stop(color: Color("ShapeFillGray"), location: 0),
            Gradient.Stop(color: Color("ShapeFillDarkGray"), location: 0.25),
            Gradient.Stop(color: Color("ShapeFillGray"), location: 0.5),
            Gradient.Stop(color: Color("ShapeFillDarkGray"), location: 0.75),
            Gradient.Stop(color: Color("ShapeFillGray"), location: 1)
        ],center: .center))
    }
    
    public func strokeAngular(_ lineWidth: CGFloat) -> some View {
        self.stroke(AngularGradient(stops: [
            Gradient.Stop(color: Color("ShapeStrokeDarkGray"), location: 0),
            Gradient.Stop(color: Color(white: 0, opacity: 0.1), location: 0.3),
            Gradient.Stop(color: Color("ShapeStrokeDarkGray"), location: 1)
        ], center: .center), lineWidth: lineWidth)
    }

}

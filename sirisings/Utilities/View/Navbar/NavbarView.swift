//
//  NavbarView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct NavbarView: View {
    
    var leftTitle = "Back"
    var rightTitle = "Done"
    
    var leftAction: (() -> Void)?
    var rightAction: (() -> Void)?
    
    var body: some View {
        HStack {
            if leftAction != nil {
                NavbarButton(title: leftTitle, action: leftAction!)
            }
            Spacer()
            if rightAction != nil {
                NavbarButton(title: rightTitle, action: rightAction!)
            }
        }
    }
}

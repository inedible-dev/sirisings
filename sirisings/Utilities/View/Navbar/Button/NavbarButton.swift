//
//  NavbarButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct NavbarButton: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .padding()
        }
    }
}

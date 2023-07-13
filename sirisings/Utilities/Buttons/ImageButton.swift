//
//  ImageButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import SwiftUI

struct ImageButton: View {
    
    var systemName: String
    var size: CGFloat?
    var action: () -> Void
    
    var body: some View {
        Button(action: { action() }) {
            Image(systemName: systemName)
                .font(size != nil ? .system(size: size!) : .title2)
                .foregroundColor(.white)
        }.padding(10)
    }
}

//
//  PreviewLyricsBlockView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import SwiftUI

struct PreviewLyricsBlockView: View {
    
    var lyric: String
    
    var body: some View {
        HStack {
            Text(lyric)
            Spacer()
        }.frame(alignment: .leading)
            .padding(20)
            .background(Color.init(white: 0.2))
            .cornerRadius(18)
            .font(.title.weight(.semibold))
            .foregroundColor(Color.white)
    }
}

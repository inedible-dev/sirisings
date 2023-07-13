//
//  LyricsTextEditor.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 13/4/23.
//

import SwiftUI

struct LyricsTextEditor: View {
    
    @Binding var lyrics: String
    
    var body: some View {
        HStack {
            if #available(iOS 16, *) {
                TextEditor(text: $lyrics)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(Color.init(white: 0.17))
                    .cornerRadius(12)
            } else {
                TextEditor(text: $lyrics)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
        }
        .overlay(
            Text(lyrics.isEmpty ? "Enter your lyrics here..." : "")
                    .padding(.vertical, 24)
                    .padding(.horizontal, 20)
                    .foregroundColor(.gray)
                    .frame(maxWidth: 700, maxHeight: 400, alignment: .topLeading)
            )
        .frame(maxWidth: 700, maxHeight: 400)
    }
}

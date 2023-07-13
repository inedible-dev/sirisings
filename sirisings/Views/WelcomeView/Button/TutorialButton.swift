//
//  TutorialButton.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 17/4/23.
//

import SwiftUI

struct TutorialButton: View {
    @EnvironmentObject var viewManager: ViewManager
    
    @State private var showTutorial = false
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        Button(action: {
            showTutorial.toggle()
        }) {
            HStack {
                Text("Tutorial")
                Spacer()
                Image(systemName: "doc.fill")
            }.font(isIpad ? .body.weight(.semibold) : .system(size: 14, weight: .semibold))
                .padding(14)
                .frame(maxWidth: 400)
                .background(Color("BrightPurple"))
                .foregroundColor(.white)
                .cornerRadius(12)
        }.buttonStyle(ScaleButtonStyle())
            .fullScreenCover(isPresented: $showTutorial, content: TutorialView.init)
    }
}

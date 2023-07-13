//
//  WelcomeView.swift
//  wwdc23
//
//  Created by Wongkraiwich Chuenchomphu on 3/4/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var manager: LyricsManager
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        VStack {
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: isIpad ? 300 : 250)
                .padding(.bottom, isIpad ? 16 : 32)
            VStack {
                Text("Welcome to")
                    .font(.title.weight(.medium))
                Text("Siri Sings!")
                    .foregroundStyle(LinearGradient(.siriSingsBGR))
                    .font(.system(size: 86, weight: .semibold))
                    .minimumScaleFactor(0.5)
                Text("Let Siri sing some songs for you!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    HStack {
                        GetStartedButton()
                        if manager.checkLastSession() {
                            RestoreLastSessionButton()
                        }
                    }.frame(maxWidth: 400)
                    TutorialButton()
                    ImportLyricsButton()
            }.foregroundColor(.white)
                .padding()
        }.padding()
    }
}

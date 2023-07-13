//
//  TutorialView.swift
//  
//
//  Created by Wongkraiwich Chuenchomphu on 16/4/23.
//

import SwiftUI

struct TutorialView: View {
    
    @Environment(\.dismiss) var dismissView
    
    enum Views {
        case preButton, playButton, houseButton, saveButton, clearButton, waveButton, upButton
    }
    
    private let contents: [(title: String, description: String, iconName: String?, imageName: String?, noShadow: Bool, view: Views?)] = [
        (
            "Welcome to SiriSings!",
            "A Playground where you could make Apple's Text to Speech Sing!",
            nil,
            "AppLogo",
            true,
            nil
        ),
        (
            "Have a SiriSings Lyrics File?",
            "Press the Import Lyrics Button to import the JSON File",
            nil,
            "WelcomeViewInit",
            false,
            nil
        ),
        (
            "Accidentally Closed the App?",
            "Restore your previous session by pressing the Restore Session Button",
            nil,
            "WelcomeViewRestore",
            false,
            nil
        ),
        (
            "Preview your Lyrics",
            "Press the Preview Button on the Top Right Corner to Preview your Lyrics",
            nil,
            "WelcomeViewRestore",
            false,
            nil
        ),
        (
            "Select and Control",
            "Select the Lyrics Block that you want to Edit, control it on the Right Panel",
            nil,
            "LyricsView",
            false,
            nil
        ),
        (
            "Preview Selected Block",
            "Click the Orange PRE Button to Preview your Currently Selected Block",
            nil,
            "LyricsView",
            false,
            .preButton
        ),
        (
            "Playback Lyrics",
            """
            Play or Pause your lyrics by Clicking the Green Play Button
            
            While Playing, you could press your desired Lyric Block to skip to it
            """,
            nil,
            "LyricsView",
            false,
            .playButton
        ),
        (
            "Close the Session",
            "Close the Current Session by tapping the House Button",
            nil,
            "LyricsView",
            false,
            .houseButton
        ),
        (
            "Save the Session",
            "Save your Session by tapping the Save icon to a save as an JSON File and share with others",
            nil,
            "SaveSessionSheet",
            false,
            .saveButton
        ),
        (
            "Delete the Session",
            "Delete your session by clicking the X Icon",
            nil,
            "LyricsView",
            false,
            .clearButton
        ),
        (
            "Preview with Backing Track",
            "Preview your Lyrics with a Backing Track by hitting the Wave Button",
            nil,
            "PreviewWithBackingTrackSheet",
            false,
            .waveButton
        ),
        (
            "Rewind to the Top",
            """
            When previewing with the Backing Track, you could only start preview from the top
            
            To rewind to start, press the Up Arrow Button
            """,
            nil,
            "PreviewWithBackingTrackSheet",
            false,
            .upButton
        ),
    ]
    
    var body: some View {
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        VStack {
            NavbarView(rightAction: { dismissView() })
            TabView {
                ForEach(contents.indices, id: \.self) { index in
                    ScrollViewIfNeeded {
                        VStack(alignment: .center, spacing: 10) {
                            VStack {
                                if contents[index].imageName != nil {
                                    Image(contents[index].imageName!)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(maxHeight: 350)
                                        .shadow(color: contents[index].noShadow ? .clear : .init(white: 0.6), radius: 20, x: 0, y: 0)
                                        .padding()
                                        .padding(.vertical, 30)
                                }
                                VStack {
                                    Text(contents[index].title)
                                        .font(isIpad ? .system(size: 44, weight: .bold) : .title2.weight(.semibold))
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                    Text(contents[index].description)
                                        .font(isIpad ? .title3 : .body)
                                        .foregroundColor(.init(white: 0.6))
                                        .padding(.horizontal)
                                }.padding(.vertical, isIpad ? 30 : 10)
                                VStack {
                                    if contents[index].view != nil {
                                        switch contents[index].view! {
                                        case .preButton:
                                            Button(action: {}) {
                                                Text("PRE")
                                            }.buttonStyle(CircleButtonStyle(color: "PreOrange", isPlaying: false))
                                        case .playButton:
                                            Button(action: {}) {
                                                Image(systemName: "playpause.fill")
                                            }.buttonStyle(CircleButtonStyle(color: "PlayGreen", isPlaying: false))
                                        case .upButton:
                                            Button(action: {}) {
                                                Image(systemName: "arrow.up")
                                            }.buttonStyle(CircleButtonStyle(color: "PreOrange", isPlaying: false))
                                        case .houseButton:
                                            ImageButton(systemName: "house.fill", size: 50) {}
                                        case .saveButton:
                                            ImageButton(systemName: "square.and.arrow.down.fill", size: 50) {}
                                        case .clearButton:
                                            ImageButton(systemName: "xmark.app.fill", size: 50) {}
                                        case .waveButton:
                                            ImageButton(systemName: "waveform.circle.fill", size: 50) {}
                                        }
                                    }
                                }.padding(.vertical, 24)
                            }
                        }.multilineTextAlignment(.center)
                    }
                }
            }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }.padding()
    }
}

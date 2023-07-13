import SwiftUI
import AVFAudio

@main
struct sirisingsApp: App {
    @StateObject var lyricsManager = LyricsManager()
    @StateObject var viewManager = ViewManager()
    
    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .onAppear() {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback)
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        viewManager.audioSessionInitFailed.toggle()
                    }
                }.environmentObject(lyricsManager)
                .environmentObject(viewManager)
                .preferredColorScheme(.dark)
        }
    }
}

//
//  RhythmAndCoApp.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import AudioKit
import SwiftUI
import AVFAudio

@main
struct RhythmAndCoApp: App {
    init() {
        #if os(iOS)
            do {
                Settings.bufferLength = .short
                try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                                options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let err {
                print(err)
            }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            //PlayView(fileName: "arctic", trackIndex: 0)
            ContentView()
        }
    }
}

// Define routes of the app
enum AppRoute: Equatable {
    case Home
    case Play(fileURL: URL?, trackIndex: Int)  // Typesafe parameters
}

//
//  HomeViewModel.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 11.01.2023.
//

import SwiftUI
import AudioKit

class HomeViewModel: ObservableObject {
    @Published var tracks = [MIDIFileTrack]()
    
    func fetchTracks(for fileURL: URL?) {
        if let url = fileURL {
            let midiFile   = MIDIFile(url: url)
            tracks = midiFile.tracks
        }
    }
    
    
}

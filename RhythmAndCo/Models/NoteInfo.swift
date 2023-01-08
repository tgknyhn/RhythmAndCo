//
//  NoteInfo.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 7.01.2023.
//

import Foundation
import AudioKit

struct NoteInfo {
    public let id: Int
    public let note: MIDINoteDuration
    public let noteName: String
    
    init(id: Int, note: MIDINoteDuration, noteName: String) {
        self.id = id
        self.note = note
        self.noteName = noteName
    }
}

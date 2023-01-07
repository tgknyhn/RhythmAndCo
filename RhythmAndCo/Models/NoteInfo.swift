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
    
    init(id: Int, note: MIDINoteDuration) {
        self.id = id
        self.note = note
    }
}

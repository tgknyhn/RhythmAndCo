//
//  NoteInfo.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 7.01.2023.
//

import Foundation
import AudioKit
import SwiftUI

struct NoteInfo {
    public let id: Int
    public let note: MIDINoteDuration
    public let noteName: String
    public var color: Color
    
    init(id: Int, note: MIDINoteDuration, noteName: String, color: Color) {
        self.id = id
        self.note = note
        self.noteName = noteName
        self.color = color
    }
}

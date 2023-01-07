//
//  PlayViewModel.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 28.12.2022.
//

import SwiftUI
import AudioKit
 
class PlayViewModel: ObservableObject {
    @Published var songNotes = [MIDINoteDuration]()      // Notes in the song
    @Published var currentNote: String = "Empty"
    @Published var currentKey: String = "C"
    @Published var currentSuffix: String = "6"
    @Published var currentNoteIndex: Int = -1
    @Published var receivedNote: String = "-"
    
    func fetchSongNotes(for fileURL: URL?, track: Int) {
        if let url = fileURL {
            let midiFile   = MIDIFile(url: url)
            let trackNoteMap = MIDIFileTrackNoteMap(midiFile: midiFile, trackNumber: track)
            
            
            debugPrint("division: \(midiFile.timeDivision)")
            debugPrint("ticksperframe: \(midiFile.ticksPerFrame ?? 0)")
            debugPrint("ticksperbeat: \(midiFile.ticksPerBeat ?? 0)")
            
            
            
            songNotes = trackNoteMap.noteList
            // Adding 5 empty note
            (0 ..< 5).forEach({ i in songNotes.append(MIDINoteDuration.init(noteOnPosition: Double(i), noteOffPosition: Double(i+1), noteNumber: 0)) })
            //nextNote()
        }
    }
    
    func nextNote() {
        // Changing current note
        if currentNoteIndex < songNotes.count - 6 {
            currentNoteIndex += 1
        }
        
        currentNote = noteNumberToNoteName(for: songNotes[currentNoteIndex].noteNumber)
        currentKey = getKey()
        currentSuffix = getSuffix()
    }

    func getKey() -> String {
        return String(currentNote.prefix(currentNote.count-1))
    }
    
    func getSuffix() -> String {
        return String(currentNote.suffix(1))
    }
    
    func compareCurrentNote(with receivedNote: String) {
        if currentNote == receivedNote {
            nextNote()
        }
    }

    
    func noteNumberToNoteName(for note: Int) -> String {
        // Every note possible (A, B, ... , F#, etc)
        let allNotes = Notes()
        // First we convert note string to integer
        var noteNumber = note
        // Then, we substract 12 from the noteNumber (A0 starts at note number 12)
        noteNumber -= 12
        // Second, we calculate the octave
        let octave = noteNumber / 12
        // Lastly, we get note name from Notes model
        let noteName = allNotes.getNote(for: noteNumber % 12)
        // return the result
        return noteName + String(octave);
    }
    
    func getFileName(for url: URL?) -> String {
        var fileName: String = url?.lastPathComponent ?? "Empty"
        
        if(fileName == "Empty") {
            return fileName
        }
        
        (1...4).forEach { _ in
            fileName.removeLast()
        }
        
        return fileName.uppercased()
    }
}


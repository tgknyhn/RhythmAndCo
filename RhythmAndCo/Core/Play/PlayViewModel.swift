//
//  PlayViewModel.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 28.12.2022.
//

import SwiftUI
import AudioKit
import Fretboard
 

class PlayViewModel: ObservableObject {
    @Published var songNotes = [MIDINoteDuration]()      // Notes in the song
    @Published var currentNote: String = "Empty"
    @Published var currentNoteIndex: Int = -1
    @Published var receivedNote: String = "-"
    
    func fetchSongNotes(for fileURL: URL?, track: Int) {
        if let url = fileURL {
            let midiFile   = MIDIFile(url: url)
            let trackNoteMap = MIDIFileTrackNoteMap(midiFile: midiFile, trackNumber: track)
            
            debugPrint("track: \(midiFile.filename)")
            
            songNotes = trackNoteMap.noteList
            nextNote()
        }
    }
    
    func nextNote() {
        // Changing current note
        if currentNoteIndex < songNotes.count - 1 {
            currentNoteIndex += 1
        }
        currentNote = noteNumberToNoteName(for: songNotes[currentNoteIndex].noteNumber)
    }

    func compareCurrentNote(with receivedNote: String) {
        if currentNote == receivedNote {
            nextNote()
        }
    }
    
    func getFretBoard(for note: String, with suffix: String) -> some View {
        let guitar = Instrument.guitar
        let dAug9Positions = guitar.findChordPositions(key: note, suffix: suffix)
        
        //getFretBoard(for: Instrument.guitar.keys[4], with: Instrument.guitar.suffixes[0])

        
        return FretboardView(position: dAug9Positions[3])
            .frame(width: 200, height: 350)
            
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


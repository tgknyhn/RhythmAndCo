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
    @Published var nextTenNotes = [String]()
    @Published var currentNote: String = "Empty"
    @Published var currentNoteIndex: Int = 0
    // Audio model
    @Published var receivedNote: String = "-"
    

    
    public var songNotes = [String]()      // Notes in the song
    
    
    init() {
        fetchSongNotes(for: "doi")
        initNotes()
    }

    func initNotes() {
        // Initializing current note
        currentNote = songNotes[currentNoteIndex]
        // Adding 10 song notes
        for i in 0..<10 {
            nextTenNotes.append(songNotes[i])
        }
    }
    
    func fetchSongNotes(for song: String) {
        let fileURL : URL? = Bundle.main.url(forResource: song, withExtension: "mid")
        var tempName: String

        if let url = fileURL {
            let midiFile   = MIDIFile(url: url)
            let midiTrack  = midiFile.tracks[0]
            let midiEvents = midiTrack.events
            
            for event in midiEvents {
                if let noteNumber = event.noteNumber {
                    tempName = noteNumberToNoteName(for: noteNumber.description)
                    songNotes.append(tempName)
                }
            }
        }
    }
    
    func nextNote() {
        // Changing current note
        if currentNoteIndex < songNotes.count - 1 {
            currentNoteIndex += 1
        }
        currentNote = songNotes[currentNoteIndex]
        // Changing next 5 note
        nextTenNotes.remove(at: 0)
        nextTenNotes.append(songNotes[currentNoteIndex+9])
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
            .frame(width: 200, height: 400)
            
    }
    
    func noteNumberToNoteName(for note: String) -> String {
        // Every note possible (A, B, ... , F#, etc)
        let allNotes = Notes()
        // First we convert note string to integer
        var noteNumber = Int(note) ?? 0
        // Then, we substract 12 from the noteNumber (A0 starts at note number 12)
        noteNumber -= 12
        // Second, we calculate the octave
        let octave = noteNumber / 12
        // Lastly, we get note name from Notes model
        let noteName = allNotes.getNote(for: noteNumber % 12)
        // return the result
        return noteName + String(octave);
    }
}


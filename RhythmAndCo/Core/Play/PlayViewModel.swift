//
//  PlayViewModel.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 28.12.2022.
//

import SwiftUI
import AudioKit
import AVFoundation
 
class PlayViewModel: ObservableObject {
    @Published var songNotes = [MIDINoteDuration]()      // Notes in the song
    @Published var noteInfo = [NoteInfo]()
    @Published var currentNote: String = "Empty"
    @Published var currentKey: String = "C"
    @Published var currentSuffix: String = "6"
    @Published var currentNoteIndex: Int = -1
    @Published var textColors = [Color]()
    @Published var textColor: Color = Color.black
    private var mistakeCount: Int = 0
    private var mistakeLimit: Int = 6

    func fetchSongNotes(for fileURL: URL?, track: Int) {
        if let url = fileURL {
            let midiFile   = MIDIFile(url: url)
            let trackNoteMap = MIDIFileTrackNoteMap(midiFile: midiFile, trackNumber: track)
            
            
            //debugPrint("division: \(midiFile.timeDivision)")
            //debugPrint("ticksperframe: \(midiFile.ticksPerFrame ?? 0)")
            //debugPrint("ticksperbeat: \(midiFile.ticksPerBeat ?? 0)")
            
            
            
            songNotes = trackNoteMap.noteList
            // Adding 5 empty note
            (0 ..< 5).forEach({ i in songNotes.append(MIDINoteDuration.init(noteOnPosition: Double(i), noteOffPosition: Double(i+1), noteNumber: 0)) })
            //nextNote()
            
            (0 ..< songNotes.count).forEach { index in
                noteInfo.append(NoteInfo(id: index,
                                         note: songNotes[index],
                                         noteName: noteNumberToNoteName(for: songNotes[index].noteNumber), color: Color.gray))
                textColors.append(Color.gray)
            }
        }
    }
    
    func nextNote() {
        // Changing current note
        if currentNoteIndex < songNotes.count - 6 {
            currentNoteIndex += 1
        }
        
        currentNote = noteNumberToNoteName(for: noteInfo[currentNoteIndex].note.noteNumber)
        currentKey = getKey()
        currentSuffix = getSuffix()
    }

    func getKey() -> String {
        return String(currentNote.prefix(currentNote.count-1))
    }
    
    func getSuffix() -> String {
        return String(currentNote.suffix(1))
    }
    
    func compareCurrentNote(receivedNote: String) {
        if currentNote == receivedNote {
            nextNote()
            mistakeCount = 0
            textColor = Color.green
        }
        else if mistakeCount == mistakeLimit {
            nextNote()
            mistakeCount = 0
            textColor = Color.red
        }
    }

    
    func noteNumberToNoteName(for note: Int) -> String {
        if note == 0 {
            return " "
        }
        // Every note possible (A, B, ... , F#, etc)
        let allNotes = NoteSyntax()
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
        
        if fileName.hasSuffix(".mid") {
            (0..<4).forEach { _ in
                fileName.removeLast()
            }
        }
        else if fileName.hasSuffix(".midi") {
            (0..<5).forEach { _ in
                fileName.removeLast()
            }
        }
        else if fileName.hasSuffix(".mid.html") {
            (0..<9).forEach { _ in
                fileName.removeLast()
            }
        }
        else if fileName.hasSuffix(".midi.html") {
            (0..<10).forEach { _ in
                fileName.removeLast()
            }
        }
        
        return fileName.capitalized
    }
    
    func getReceivedNoteColor(isPlaying: Bool, receivedNote: String) {
        if isPlaying == true {
            return textColor = Color.gray
        }
        else if mistakeCount < mistakeLimit {
            return mistakeCount += 1
        }
    }
}


//
//  PlayView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import AudioKit
import AudioKitUI
import Fretboard


struct PlayView: View {
    // Initializing the viewmodels
    @StateObject var midiTrackViewModel = MIDITrackViewModel()      // From AudiokitUI
    @StateObject var conductor = AudioRecognition()                 // From Audiokit
    @StateObject var playViewModel = PlayViewModel()                // My ViewModel
    // Song Information
    @State var fileURL: URL?
    @State var trackIndex: Int = 0
    @State var isPlaying = false
    
    init(fileName: String, trackIndex: Int) {
        // Initializing song file
        _fileURL    = State(initialValue: Bundle.main.url(forResource: fileName, withExtension: "mid")!)
        _trackIndex = State(initialValue: trackIndex)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    SongNameView(songName: playViewModel.getFileName(for: fileURL))
                    HStack {
                        Spacer()
                        PauseButtonView()
                    }
                }
                Spacer(minLength: 40)
                GameScoreView()
                Spacer(minLength: 30)
                CurrentNoteView(currentNote: playViewModel.currentNote)
                MidiTrackView(fileURL: fileURL, trackIndex: trackIndex)
                HStack(spacing: 50) {
                    FreatboardView(playViewModel: playViewModel)
                    ZStack {
                        SongNotesScrollView(playViewModel: playViewModel)
                            .padding(.top, 12)
                        VStack {
                            Circle().stroke(Color.black,
                                            style: StrokeStyle(lineWidth: 5,
                                                               lineCap: .butt,
                                                               dash: [10,5]))
                            Spacer()
                        }
                    }
                }
                .padding(.trailing, geometry.size.width / 8)
                
            }
            .padding(.horizontal)
            .padding(.bottom, 1)
            .onAppear() {
                // Sending info to the viewmodel to get song information
                playViewModel.fetchSongNotes(for: fileURL, track: trackIndex)
                // initializing the midi track viewmodel
                midiTrackViewModel.startEngine()
                if let fileURL = fileURL {
                    midiTrackViewModel.loadSequencerFile(fileURL: fileURL)
                }
            }
            .onTapGesture {
                isPlaying.toggle()
            }
            .onChange(of: isPlaying, perform: { newValue in
                if newValue == true {
                    midiTrackViewModel.play()
                } else {
                    midiTrackViewModel.stop()
                }
            })
            .onDisappear(perform: {
                midiTrackViewModel.stop()
                midiTrackViewModel.stopEngine()
            })
        .environmentObject(midiTrackViewModel)
        }
    }
    
    
    
    
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(fileName: "arctic", trackIndex: 0)
    }
}


//            Button("Nex") {
//                playViewModel.nextNote()
//            }
//            Text("\(playViewModel.songNotes.count)")

    
    /*
    ScrollView(.horizontal) {
        HStack {
            ForEach(playViewModel.nextTenNotes, id: \.self) { note in
                Text(note)
            }
        }
    }
    
    Text(playViewModel.currentNote)
        .font(.system(size: 50))
    
    Button("Next") {
        playViewModel.nextNote()
    }
    Text("Note Name")
        .bold()
        .font(.system(size: 40))
        .underline(true)
    Text("")
    Text("\(conductor.data.noteNameWithSharps)")
        .font(.system(size: 30))
     playViewModel.getFretBoard(for: Instrument.guitar.keys[0], with: Instrument.guitar.suffixes[2])
    */
//}
//
//        .onAppear() {
//            conductor.start()
//
//        }
//        .onDisappear() {
//            conductor.stop()
//        }
//        .onChange(of: conductor.data.amplitude) { amp in
//            guard amp > 0.3 else { return }
//            playViewModel.compareCurrentNote(with: conductor.data.noteNameWithSharps)
//        }


struct SongNameView: View {
    let songName: String
    
    var body: some View {
        Text(songName)
            .font(.title)
            .fontWeight(.bold)
    }
}

struct PauseButtonView: View {
    let dimensions = 20.0
    
    var body: some View {
        Button {
            print("Edit button was tapped")
        } label: {
            Image(systemName: "pause.fill")
                .resizable()
                .frame(width: dimensions, height: dimensions)
                .foregroundColor(.black)
        }
    }
}

struct GameScoreView: View {
    var correct: Int = 0
    var score: Int = 0
    var misplay: Int = 0
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                Text("Correct")
                    .font(.title3)
                    .fontWeight(.bold)
                    .underline()
                Text("\(correct)")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Spacer()
            VStack(spacing: 5) {
                Text("Score")
                    .font(.title3)
                    .fontWeight(.bold)
                    .underline()
                Text("\(score)")
                    .font(.headline)
                    .foregroundColor(.yellow)
            }
            
            Spacer()
            VStack(spacing: 5) {
                Text("Misplay")
                    .font(.title3)
                    .fontWeight(.bold)
                    .underline()
                Text("\(misplay)")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
    }
}

struct CurrentNoteView: View {
    let currentNote: String
    
    var body: some View {
        Text(currentNote)
            .font(.title)
            .fontWeight(.bold)
    }
}

struct MidiTrackView: View {
    @State var fileURL: URL?
    @State var trackIndex: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            if let _ = fileURL {
                MIDITrackView(fileURL: $fileURL,
                              trackNumber: trackIndex,
                              trackWidth: geometry.size.width,
                              trackHeight: 200)
                .background(Color.primary)
                .cornerRadius(10.0)
                
            }
        }
    }
}

struct SongNotesScrollView: View {
    var playViewModel: PlayViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(playViewModel.songNotes, id: \.self.noteStartTime) { noteInfo in
                    Text(playViewModel.noteNumberToNoteName(for: noteInfo.noteNumber))
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
        }
    }
}

struct FreatboardView: View {
    var playViewModel: PlayViewModel
    
    var body: some View {
        playViewModel.getFretBoard(for: Instrument.guitar.keys[4], with: Instrument.guitar.suffixes[0])
    }
}

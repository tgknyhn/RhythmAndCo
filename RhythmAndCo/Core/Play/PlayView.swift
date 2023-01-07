//
//  PlayView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import AudioKit
import AudioKitUI


struct PlayView: View {
    // Initializing the viewmodels
    @StateObject var midiTrackViewModel = MIDITrackViewModel()      // From AudiokitUI
    @StateObject var conductor = AudioRecognition()                 // From Audiokit
    @StateObject var playViewModel = PlayViewModel()                // My ViewModel
    // Song Information
    @State var fileURL: URL?
    @State var trackIndex: Int = 0
    @State var isPlaying = false
    @State var startTimeInMs = 0.0
    @State var test = 0
    // Clock system
    @State var timeElapsedInMs = 0.0      // Shows elapsed time in millisecond
    @State var timerRunning = true
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    // Guitarboard object
    let guitar = Instrument.guitar
    
    
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
                //CurrentNoteView(currentNote: playViewModel.currentNote)
                MidiTrackView(fileURL: fileURL, trackIndex: trackIndex)
                HStack(alignment: .top, spacing: 50) {
                    GuitarboardView(position: guitar.findChordPositions(key: playViewModel.currentKey,
                                                                        suffix: playViewModel.currentSuffix)[0])
                    .frame(width: 200, height: 350)
                    
                    ZStack {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    Text("-")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    ForEach(playViewModel.songNotes, id: \.self.noteStartTime) { noteInfo in
                                        Text(playViewModel.noteNumberToNoteName(for: noteInfo.noteNumber))
                                            .font(.title)
                                            .fontWeight(.bold)
                                            
                                    }
                                }
                            }
                        }
                            .padding(.top, 12)
                            .padding(.bottom, -40)
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

                HStack {
                    Button("Nex") {
                        playViewModel.nextNote()
                    }
                    VStack {
                        Text("Start Time: \(startTimeInMs)")
                        Text("Elapsed Time: \(timeElapsedInMs)")
                    }
                }
                
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
                //isPlaying.toggle()
            }
            .onReceive(timer, perform: { _ in
                if playViewModel.currentNoteIndex != -1 {
                    startTimeInMs = playViewModel.songNotes[playViewModel.currentNoteIndex].noteStartTime * 1_000_000 / 3.05
                }
                
                if isPlaying == true {
                    if timeElapsedInMs <= startTimeInMs {
                        timeElapsedInMs += 10
                    }
                    else {
                        timeElapsedInMs -= 5.05
                        isPlaying.toggle()
                    }
                }
            })
            .onChange(of: isPlaying, perform: { newValue in
                if newValue == true {
                    midiTrackViewModel.play()
                } else {
                    midiTrackViewModel.stop()
                }
            })
            
            .onChange(of: playViewModel.currentNoteIndex, perform: { newValue in
                isPlaying.toggle()
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

//struct SongNotesScrollView: View {
//    var playViewModel: PlayViewModel
//    
//    var body: some View {
//        
//    }
//}

//struct FretboardView: View {
//    var playViewModel: PlayViewModel
//
//
//    var body: some View {
//        //Text(String(currentNote.suffix(1)))
//
//    }
//}

//
//  PlayView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import AudioKit
import AudioKitUI
import UIPilot
import PopupView

struct PlayView: View {
    // Routing object
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    // Initializing the viewmodels
    @StateObject var midiTrackViewModel = MIDITrackViewModel()      // From AudiokitUI
    @StateObject var conductor = AudioRecognition()                 // From Audiokit
    @StateObject var playViewModel = PlayViewModel()                // My ViewModel
    // Song Information
    @State var fileURL: URL?
    @State var trackIndex: Int = 0
    @State var isPlaying = false
    @State var startTimeInMs = 0.0
    @State var notePosition = Chord.Position(baseFret: 0,
                                            barres: [],
                                            frets: [-1, -1, -1, -1, -1, -1],
                                            fingers: [0, 0, 0, 0, 0, 0])
    // Clock system
    @State var timeElapsedInMs = 0.0      // Shows elapsed time in millisecond
    @State var timerRunning = true
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    // Guitarboard object
    let guitar = Instrument.guitar
    // Score variables
    @State var correct: Int = 0
    @State var misplay: Int = 0
    @State var scored: Bool = false
    // Button variables
    @State var gameStarted: Bool = false
    // Pop-up View
    @State var showPopUp: Bool = false
    // Scroll view scrollable
    @State var scrollDisabled: Bool = true
    
    init(fileURL: URL?, trackIndex: Int) {
        // Initializing song file
        _fileURL    = State(initialValue: fileURL)
        _trackIndex = State(initialValue: trackIndex)
    }
    
    init(fileName: String, trackIndex: Int) {
        // Initializing song file
        _fileURL    = State(initialValue: Bundle.main.url(forResource: fileName, withExtension: "mid"))
        _trackIndex = State(initialValue: trackIndex)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                SongNameView(songName: playViewModel.getFileName(for: fileURL))
                    .padding(.bottom, -10)
                Spacer(minLength: 40)
                GameScoreView(correct: correct, misplay: misplay)
                Spacer(minLength: 30)
                //CurrentNoteView(currentNote: playViewModel.currentNote)
                MidiTrackView(fileURL: fileURL, trackIndex: trackIndex)
                HStack(alignment: .top, spacing: 50) {
                    GuitarboardView(position: notePosition)
                    .frame(width: 200, height: 350)
                    
                    VStack {
                        ZStack {
                            HStack(spacing: 5) {
                                Image(systemName: "mic.fill")
                                    .imageScale(.large)
                                Text("→")
                                Spacer()
                            }.padding(.horizontal, -20)
                            HStack(spacing: 10) {
                                Spacer()
                                Text("\(conductor.data.noteNameWithSharps)")
                                    .font(.title)
                                    .foregroundColor(playViewModel.textColor)
                            }.padding(.horizontal, -20)
                        }

                        ZStack {
                            ScrollViewReader { proxy in
                                ScrollView {
                                    VStack(spacing: 20) {
                                        Text("-")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        ForEach(playViewModel.noteInfo, id: \.id) { noteInfo in
                                            Text(noteInfo.noteName)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(playViewModel.textColors[noteInfo.id])
                                        }
                                    }
                                }
                                .scrollDisabled(scrollDisabled)
                                .onChange(of: playViewModel.currentNoteIndex) { index in
                                    withAnimation {
                                        proxy.scrollTo(playViewModel.noteInfo[index].id, anchor: .top)
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
                }
                .padding(.trailing, geometry.size.width / 8)

                HStack(spacing: geometry.size.width / 5.8) {
                    Button {
                        // Stopping every view model object
                        conductor.stop()
                        isPlaying.toggle()
                        // Changing the game started value to false
                        gameStarted = false
                    } label: {
                        Image(systemName: "pause.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 18)
                            .foregroundColor(gameStarted ? .black : .gray)
                    }

                    .disabled(gameStarted == false)
                    
                    Button {
                        // Starting everthing back on
                        conductor.start()
                        if playViewModel.currentNoteIndex == -1 {
                            playViewModel.nextNote()
                        }
                        else {
                            isPlaying.toggle()
                        }
                        // Changing the game started value to true
                        gameStarted = true
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 17)
                            .foregroundColor(!gameStarted ? .black : .gray)
                    }
                    .disabled(gameStarted == true)
                    
                    Button {
                        pilot.push(.Play(fileURL: fileURL, trackIndex: trackIndex))
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 15)
                            .foregroundColor(.black)
                    }
                    
                    Button {
                        pilot.popTo(.Home)
                    } label: {
                        Image(systemName: "music.note.house.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width / 12)
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.top, 15)
                //                    VStack {
                //                        Text("Start Time: \(startTimeInMs)")
                //                        Text("Elapsed Time: \(timeElapsedInMs)")
                //                    }
            }
            .navigationBarHidden(true)
            .padding(.horizontal)
            .padding(.bottom, 1)
            .onAppear() {
                conductor.start()
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
                    startTimeInMs = playViewModel.noteInfo[playViewModel.currentNoteIndex].note.noteStartTime * 1_000_000 / 3.05
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
                // Check for final index
                if newValue == playViewModel.noteInfo.count-6 {
                    showPopUp = true
                    scrollDisabled = false
                }
                scored = false
                isPlaying.toggle()
                notePosition = guitar.findChordPositions(key: playViewModel.currentKey,
                                                         suffix: playViewModel.currentSuffix)[0]
            })
            .onChange(of: conductor.data.pitch, perform: { note in
                if isPlaying == false {
                    playViewModel.compareCurrentNote(receivedNote: conductor.data.noteNameWithSharps)
                    playViewModel.getReceivedNoteColor(isPlaying: isPlaying, receivedNote: conductor.data.noteNameWithSharps)
                    
                    if playViewModel.currentNoteIndex != -1 {
                        playViewModel.textColors[playViewModel.currentNoteIndex] = playViewModel.textColor
                    }
                    
                    if playViewModel.textColor == Color.red && scored == false {
                        misplay += 1
                        scored = true
                    }
                    else if playViewModel.textColor == Color.green && scored == false {
                        correct += 1
                        scored = true
                    }
                }
            })
            .onDisappear(perform: {
                conductor.stop()
                midiTrackViewModel.stop()
                midiTrackViewModel.stopEngine()
            })
            .environmentObject(midiTrackViewModel)
            .popup(isPresented: $showPopUp) {
                VStack {
                    Text("Congratulasions!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("You finished the song.")
                        .font(.title2)
                        .bold()
                        .padding(.bottom)
                    
                    Text("Correct Play Count")
                        .font(.title3)
                        .underline()
                        .bold()
                    Text("\(correct)")
                        .padding(.bottom, 5)
                    
                    Text("Misplayed")
                        .font(.title3)
                        .underline()
                        .bold()
                    
                    Text("\(misplay)")
                    
                    Text("Now you can play the same song again by pressing the reset button, go home and select a new song to play or analyze the notes to see which notes you have played wrong. Scroll feature is now enabled for notes.")
                        .font(.system(size: geometry.size.width / 25))
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    Text("To close this window tap outside.")
                        .font(.caption)
                    Spacer()
                }
                .frame(width: geometry.size.width / 1.2, height: geometry.size.height / 1.6)
                .background(Color.mint)
                .cornerRadius(30.0)
                .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 6)
                )
                    
            } customize: {
                $0.closeOnTapOutside(true)
            }
        }
        .blur(radius: showPopUp ? 10 : 0)
    }
    
    
    
    
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(fileName: "arctic", trackIndex: 0)
    }
}
    

struct SongNameView: View {
    let songName: String
    
    var body: some View {
        Text(songName)
            .font(.title)
            .fontWeight(.bold)
    }
}

struct ResetButtonView: View {
    let dimensions = 20.0
    
    var body: some View {
        Button {
            print("Edit button was tapped")
        } label: {
            Image(systemName: "restart.circle.fill")
                .resizable()
                .frame(width: dimensions, height: dimensions)
                .foregroundColor(.black)
        }
    }
}

struct GameScoreView: View {
    var correct: Int
    var misplay: Int
    
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

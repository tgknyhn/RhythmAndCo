//
//  PlayView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import AudioKit
import SwiftUI


struct PlayView: View {
    // Initializing the viewmodels
    @StateObject var playViewModel = PlayViewModel()
    @StateObject var conductor = AudioRecognition()

    var body: some View {
        VStack {
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
        }
        .onAppear() {
            conductor.start()
            
        }
        .onDisappear() {
            conductor.stop()
        }
        .onChange(of: conductor.data.amplitude) { amp in
            guard amp > 0.1 else { return }
            playViewModel.compareCurrentNote(with: conductor.data.noteNameWithSharps)
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}

//
//  ContentView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 14.01.2023.
//

import SwiftUI
import UIPilot

struct ContentView: View {
    // Routing object
    @StateObject var pilot = UIPilot(initial: AppRoute.Home)
    
    var body: some View {
            UIPilotHost(pilot)  { route in
                switch route {
                    case .Home: HomeView()
                    case .Play(let url, let index): PlayView(fileURL: url, trackIndex: index)
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

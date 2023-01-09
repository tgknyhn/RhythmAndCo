//
//  ContentView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import Foundation

struct HomeView: View {
    @State private var showActionSheet = false
    @State private var fileURL: URL?
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PlayView(fileURL: fileURL, trackIndex: 0)) {
                    Text("hey")
                }
                Button("Press") {
                    showActionSheet = true
                }
                .fileImporter(isPresented: $showActionSheet, allowedContentTypes: [.data]) { (res) in
                    print("!!!\(res)")
                    do {
                        try fileURL = res.get()
                    } catch {
                        
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

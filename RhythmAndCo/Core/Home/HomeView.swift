//
//  ContentView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import Foundation

struct HomeView: View {
    var playViewModel = PlayViewModel()
    @State var result: String = "hi"
    
    var body: some View {
        VStack {
            Text(result)
            Button {
                result = playViewModel.fetchDownloadsFolderURL()
            } label: {
                Text("click")
            }
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

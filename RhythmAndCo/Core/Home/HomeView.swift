//
//  ContentView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import Foundation
import UIPilot

struct HomeView: View {
    // Routing object
    @EnvironmentObject var pilot: UIPilot<AppRoute>
    // Viewmodel
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var showActionSheet = false
    @State private var fileURL: URL?
    @State var fileName: String = "No file selected"
    @State var trackIndex: Int = -1
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width / 2)
                    .padding(.top, -30)
                
                Group {
                    Image("MidiFileLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width / 6)
                    
                    Text("Upload a Song")
                        .titleTextView()
                    
                    Text("First you need to upload the song you want to play in .mid format")
                        .infoTextView()

                    Button {
                        showActionSheet = true
                    } label: {
                        Text("Upload")
                            .buttonTextView()
                    }
                    .buttonStyle(MainButton(buttonColor: Color("LogoOrange")))
                    .fileImporter(isPresented: $showActionSheet, allowedContentTypes: [.data]) { (res) in
                        do {
                            try fileURL = res.get()
                            _ = fileURL?.startAccessingSecurityScopedResource()
                            homeViewModel.fetchTracks(for: fileURL)
                            //print("\(fileURL?.description ?? "aa")")
                            fileName = fileURL?.lastPathComponent ?? "Error occured while getting file name."
                            trackIndex = -1
                        } catch {
                            fileName = "Couldn't find the file."
                        }
                    }
                    
                    HStack {
                        
                        Text("Selected file: ")
                            .selectedItemTextView()
                            .fontWeight(.bold)
                            .padding(.trailing, -8)
                        
                        Text(fileName)
                            .selectedItemTextView()
                    }
                }
                Spacer()
                Group {
                    Image("TrackLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width / 6)
                    
                    Text("Choose the Track")
                        .titleTextView()
                    
                    Text("Songs have different tracks for each instrument. Here you can select which one you want to play")
                        .infoTextView()
                    
                    ZStack {
                        Button {
                            
                        } label: {
                            Text(" ")
                                .buttonTextView()
                        }
                        .buttonStyle(MainButton(buttonColor: Color("LogoOrange")))
                        
                            
                        Menu {
                            ForEach(0 ..< homeViewModel.tracks.count, id: \.self) { index in
                                Button {
                                    trackIndex = index
                                } label: {
                                    
                                    Text("Track \(index+1): \(homeViewModel.tracks[index].name ?? "no name")") +
                                    Text("\nNote Count: \(homeViewModel.tracks[index].events.count)")
                                    Text("\nNote Count: \(homeViewModel.tracks[index].events.count)")
                                }
                            }
                        } label: {
                            Text("Select")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .disabled(fileName == "No file selected")

                        
                    }
                    
                    Text("(Selecting a guitar track is suggested)")
                        .hintTextView()
                        
                    
                    HStack {
                        Text("Selected track: ")
                            .selectedItemTextView()
                            .fontWeight(.bold)
                            .padding(.trailing, -8)
                            .padding(.top, 1)
                        
                        if fileName == "No file selected" {
                            Text("First select a file")
                                .selectedItemTextView()
                        }
                        else if trackIndex == -1 {
                            Text("Select a track")
                                .selectedItemTextView()
                        }
                        else {
                            Text("\(homeViewModel.tracks[trackIndex].name ?? String(trackIndex))")
                                .selectedItemTextView()
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    pilot.push(.Play(fileURL: fileURL, trackIndex: trackIndex))
                } label: {
                    Text("Play")
                        .buttonTextView()
                }
                .buttonStyle(MainButton(buttonColor: Color("LogoBlack")))
                .disabled(trackIndex < 0)
                
                //NavigationLink(destination: PlayView(fileURL: fileURL, trackIndex: 0)) {
                //    Text("Play")
                //        .buttonTextView()
                //}
                //.buttonStyle(MainButton(buttonColor: Color("LogoBlack")))
                //.disabled(trackIndex < 0)

            }
            .padding()
        }.navigationBarHidden(true)
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

/*
 NavigationView {
 @State private var showActionSheet = false
 @State private var fileURL: URL?

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
         Menu {
             Text("hi")
             Text("hi")
             Text("hi")
         } label: {
             Text("hi")
         }

     }
 }
 */

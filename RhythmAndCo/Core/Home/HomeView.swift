//
//  ContentView.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 27.12.2022.
//

import SwiftUI
import Foundation

struct HomeView: View {
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
                        
                    } label: {
                        Text("Upload")
                            .buttonTextView()
                    }
                    .buttonStyle(MainButton(buttonColor: Color("LogoOrange")))
                    
                    HStack {
                        
                        Text("Selected file: ")
                            .selectedItemTextView()
                            .fontWeight(.bold)
                            .padding(.trailing, -8)
                        
                        Text("No file selected")
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
                            
                        } label: {
                            Text("Select")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("(Selecting a guitar track is suggested)")
                        .hintTextView()
                    
                    HStack {
                        Text("Selected track: ")
                            .selectedItemTextView()
                            .fontWeight(.bold)
                            .padding(.trailing, -8)
                            .padding(.top, 1)
                        
                        if trackIndex == -1 {
                            Text("No track selected")
                                .selectedItemTextView()
                        } else {
                            Text("\(trackIndex)")
                                .selectedItemTextView()
                        }
                    }
                }
                
                Spacer()
                Button {
                    
                } label: {
                    Text("Play")
                        .buttonTextView()
                }
                .buttonStyle(MainButton(buttonColor: Color("LogoBlack")))
            }
            .padding()
        }
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

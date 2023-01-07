//
//  FretboardView.swift
//  FretboardView
//
//  Created by Huong Do on 23/01/2021.
//

import SwiftUI

// I get this file from https://github.com/itsmeichigo/Fretboard
public struct GuitarboardView: View {
    let fingers: [Int]
    let frets: [Int]
    let barres: [Int]
    let baseFret: Int
    let fretLineCount: Int = 14
    
        
    public init(position: Chord.Position) {
        self.fingers = position.fingers
        self.frets = position.frets
        self.barres = position.barres
        self.baseFret = position.baseFret
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                setupStrings(with: proxy)
                setupFrets(with: proxy)
                
                ForEach(0..<frets.count, id: \.self) { index in
                    Group {
                        setupStringOverlay(at: index, with: proxy)
                        
                        if shouldShowFingers(for: index) {
                            Text("\(frets[index])")
                                .foregroundColor(.primary)
                                .font(.system(size: proxy.size.width/14))
                                .frame(width: gridWidth(for: proxy),
                                       height: gridHeight(for: proxy))
                                .offset(calculateOffset(index: index, proxy: proxy, isNumber: true))
                        }
                    }
                }
                
                Group {
                    setupCapo(for: proxy)
                    
//                    if baseFret > 1 {
//                        Text("\(baseFret)fr")
//                            .foregroundColor(.primary)
//                            .font(.system(size: proxy.size.width/10))
//                            .frame(height: gridHeight(for: proxy))
//                            .offset(y: -gridHeight(for: proxy) * 3.0 - 3)
//                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    private func setupCapo(for proxy: GeometryProxy) -> some View {
        let barre = barres.first ?? 0
        let barreCount = frets.filter { $0 >= (barres.first ?? 0) }.count + frets.filter { $0 > 0 && $0 < barre }.count
        let width = gridWidth(for: proxy)
        let fretWidth = CGFloat(barreCount) * width
        let xOffset = CGFloat(frets.count - barreCount) * (width/2) * (frets[0] > 0 ? -1 : 1)
        
        return Group {
            if let barre = barres.first {
                Color.primary
                    .clipShape(Capsule())
                    .frame(width: fretWidth,
                           height: gridHeight(for: proxy)/2)
                    .offset(x: xOffset,
                            y: gridHeight(for: proxy) * CGFloat(barre - fretLineCount/2) + CGFloat(barre - fretLineCount/2))
            }
        }
    }
    
    private func gridWidth(for proxy: GeometryProxy) -> CGFloat {
        return proxy.size.width / CGFloat(frets.count + 1)
    }
    
    private func gridHeight(for proxy: GeometryProxy) -> CGFloat {
        return proxy.size.height / CGFloat(fretLineCount + 1)
    }
    
    private func setupFrets(with proxy: GeometryProxy) -> some View {
        VStack(spacing: gridHeight(for: proxy)) {
            ForEach(0..<fretLineCount, id: \.self) { index in
                Group {
                    if index > 0 && index < frets.count {
                        Color.gray
                    } else {
                        Color.primary
                    }
                }
                .frame(width: gridWidth(for: proxy) * CGFloat(frets.count-1) + CGFloat(frets.count), height: 1)
                .overlay(
                    Group {
                        if index == 0 {
                            Color.primary
                        } else {
                            Color.clear
                        }
                    }
                    .frame(height: 3)
                )
            }
        }
    }
    
    private func setupStrings(with proxy: GeometryProxy) -> some View {
        VStack {
            HStack(spacing: gridWidth(for: proxy) / 1.45) {
                Text("E")
                Text("A")
                Text("D")
                Text("G")
                Text("B")
                Text("E")
            }
            HStack(spacing: gridWidth(for: proxy)) {
                ForEach(frets, id: \.self) { s in
                    Group {
                        if s >= 0 {
                            Color.primary
                        } else {
                            Color.gray
                        }
                    }
                    .frame(width: 1,
                           height: gridHeight(for: proxy) * CGFloat(fretLineCount - 1) + CGFloat(frets.count))
                }
            }
        }.padding(.bottom, 30)
    }
    
    private func setupStringOverlay(at index: Int, with proxy: GeometryProxy) -> some View {
        Group {
            if shouldShowFingers(for: index) {
                Color.primary
                    .clipShape(Circle())
                    .padding(gridWidth(for: proxy)*0.2)
            }
//            else if frets[index] < 0 {
//                Text("✕")
//                    .foregroundColor(.gray)
//                    .font(.system(size: proxy.size.width/10))
            else if frets[index] == 0 {
                Color.primary
                    .clipShape(Circle())
                    .padding(gridWidth(for: proxy)*0.2)
                    
            }
        }
        .frame(width: gridWidth(for: proxy),
               height: gridHeight(for: proxy),
               alignment: frets[index] <= 0 ? .bottom : .center)
        .offset(calculateOffset(index: index, proxy: proxy))
    }
    
    private func shouldShowFingers(for index: Int) -> Bool {
        return frets[index] >= 0 && (barres.isEmpty || (!barres.isEmpty && frets[index] != barres.first!))
    }
    
    private func calculateOffset(index: Int, proxy: GeometryProxy, isNumber: Bool = false) -> CGSize {
        let gridSize = CGSize(width: gridWidth(for: proxy),
                              height: gridHeight(for: proxy))
        let widthCenter = CGFloat(frets.count - 1) / 2.0
        let xOffset = gridSize.width * (CGFloat(index) - widthCenter) + (CGFloat(index) - widthCenter)
        if isNumber {
            let yOffset = gridSize.height * 7 + 8
            return CGSize(width: xOffset, height: yOffset)
        } else {
            let position = frets[index]
            var yOffset = gridSize.height * CGFloat(max(position, 0) - 7) + CGFloat(max(position, 0) - 7)
            if(position == 0) {
                yOffset += 12.5
            }
            return CGSize(width: xOffset, height: yOffset)
        }
        
    }
}

struct GuitarboardView_Previews: PreviewProvider {
    
    static let dAug9Chords = Instrument.guitar.findChordPositions(key: "B", suffix: "3")
    
    //static let cMajorUkuChords = Instrument.ukulele.findChordPositions(key: "C", suffix: "major")
    
    static var previews: some View {
        GuitarboardView(position: dAug9Chords[0])
            .frame(width: 200, height: 350)
    }
}

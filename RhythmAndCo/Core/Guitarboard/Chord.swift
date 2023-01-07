//
//  Chord.swift
//
//
//  Created by Huong Do on 28/01/2021.
//


import Foundation

// I get this file from https://github.com/itsmeichigo/Fretboard
public struct Chord: Hashable, Equatable, Decodable {
    let key: String
    let suffix: String
    let positions: [Position]
    
    public struct Position: Hashable, Equatable, Decodable {
        let baseFret: Int
        let barres: [Int]
        let frets: [Int]
        let fingers: [Int]
    }
}

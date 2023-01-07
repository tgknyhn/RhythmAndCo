//
//  Notes.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 28.12.2022.
//

import Foundation

struct NoteSyntax {
    let a       : String = "A"
    let a_sharp : String = "A#"
    let b       : String = "B"
    let c       : String = "C"
    let c_sharp : String = "C#"
    let d       : String = "D"
    let d_sharp : String = "D#"
    let e       : String = "E"
    let f       : String = "F"
    let f_sharp : String = "F#"
    let g       : String = "G"
    let g_sharp : String = "G#"
    
    func getNote(for index: Int) -> String {
        switch index {
        case 0:
            return c
        case 1:
            return c_sharp
        case 2:
            return d
        case 3:
            return d_sharp
        case 4:
            return e
        case 5:
            return f
        case 6:
            return f_sharp
        case 7:
            return g
        case 8:
            return g_sharp
        case 9:
            return a
        case 10:
            return a_sharp
        case 11:
            return b
        default:
            return "Empty"
        }
    }
}

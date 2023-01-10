//
//  Button.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 10.01.2023.
//

import SwiftUI

struct MainButton: ButtonStyle {
    private let buttonColor: Color
    
    init(buttonColor: Color) {
        self.buttonColor = buttonColor
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 10)
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

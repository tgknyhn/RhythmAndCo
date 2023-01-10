//
//  TextExtension.swift
//  RhythmAndCo
//
//  Created by Tuğkan Ayhan on 10.01.2023.
//

import SwiftUI

extension Text {
    func titleTextView() -> some View {
        self.foregroundColor(Color("LogoOrange"))
            .font(.title2)
            .fontWeight(.bold)
    }
    
    func infoTextView() -> some View {
        self.font(.system(size: 15))
            .multilineTextAlignment(.center)
    }
    
    func hintTextView() -> some View {
        self.font(.caption)
            .multilineTextAlignment(.center)
    }
    
    func buttonTextView() -> some View {
        self.font(.headline)
            .frame(maxWidth: .infinity)
    }
    
    func selectedItemTextView() -> some View {
        self.font(.callout)
    }
    
    func menuTextView(color: Color) -> some View {
        self.padding(.vertical, 10)
    }
}

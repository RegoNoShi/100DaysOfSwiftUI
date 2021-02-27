//
//  Watermarked.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

struct Watermarked: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .padding(2)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .padding(2)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermarked(text: text))
    }
}

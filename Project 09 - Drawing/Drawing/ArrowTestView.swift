//
//  ArrowTestView.swift
//  Drawing
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct ArrowTestView: View {
    @State private var tipHeight = 0.3
    @State private var baseWidth = 0.5

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Button(action: {
                withAnimation {
                    tipHeight = Double.random(in: 0.05...0.95)
                    baseWidth = Double.random(in: 0.05...0.95)
                }
            }) {
                ArrowView(tipHeightPercentage: tipHeight,
                          baseWidthPercentage: baseWidth)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom))
                    .padding()
            }

            Spacer()

            Group {
                Text("Tip height: \(tipHeight)")
                Slider(value: $tipHeight.animation(), in: 0.05...1.00, step: 0.05)
                    .padding([.horizontal, .bottom])

                Text("Base width: \(baseWidth)")
                Slider(value: $baseWidth.animation(), in: 0.05...0.95, step: 0.05)
                    .padding([.horizontal, .bottom])
            }
        }
    }
}

struct ArrowTestView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowTestView()
    }
}

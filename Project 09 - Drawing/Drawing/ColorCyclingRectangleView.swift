//
//  ColorCyclingRectangleView.swift
//  Drawing
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct ColorCyclingRectangleView: View {
    var amount: CGFloat = 0.0
    var steps = 100

    var body: some View {
        ZStack {
            ForEach(0 ..< steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        color(for: value, brightness: 1),
                        color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        .drawingGroup()
    }

    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + Double(amount)

        if targetHue > 1 {
            targetHue -= 1
        }

        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ColorCyclingRectangleView_Previews: PreviewProvider {
    static var previews: some View {
        ColorCyclingRectangleView()
            .previewLayout(.fixed(width: 300.0, height: 300.0))
    }
}

//
//  ColorCyclingShapeTestView.swift
//  Drawing
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct ColorCyclingShapeTestView: View {
    private let shapes = ["Rectangle", "Circle"]
    @State private var colorCycle: CGFloat = 0.0
    @State private var steps = 100
    @State private var selectedShape = 0

    var body: some View {
        VStack {
            if selectedShape == 0 {
                ColorCyclingRectangleView(amount: colorCycle, steps: steps)
                    .padding()
            } else {
                ColorCyclingCircleView(amount: colorCycle, steps: steps)
                    .padding()
            }

            List {
                Slider(value: $colorCycle.animation())
                    .padding()

                Picker("", selection: $selectedShape.animation()) {
                    ForEach(0 ..< shapes.count) { index in
                        Text(shapes[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Color Cycling Shape")
    }
}

struct ColorCyclingShapeTestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ColorCyclingShapeTestView()
        }
    }
}

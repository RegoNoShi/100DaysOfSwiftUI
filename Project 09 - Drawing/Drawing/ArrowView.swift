//
//  ArrowView.swift
//  Drawing
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct ArrowView: Shape {
    var tipHeightPercentage: Double = 0.3
    var baseWidthPercentage: Double = 0.5

    var animatableData: AnimatablePair<Double, Double> {
        get {
           AnimatablePair(tipHeightPercentage, baseWidthPercentage)
        }

        set {
            self.tipHeightPercentage = newValue.first
            self.baseWidthPercentage = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tipHeight = CGFloat(tipHeightPercentage) * rect.height
        let baseWidth = CGFloat(baseWidthPercentage) * rect.width
        let baseXOffset = (rect.width - baseWidth) / 2

        path.move(to: CGPoint(x: 0, y: tipHeight))
        path.addLine(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: tipHeight))
        path.addLine(to: CGPoint(x: rect.width - baseXOffset, y: tipHeight))
        path.addLine(to: CGPoint(x: rect.width - baseXOffset, y: rect.height))
        path.addLine(to: CGPoint(x: baseXOffset, y: rect.height))
        path.addLine(to: CGPoint(x: baseXOffset, y: tipHeight))
        path.addLine(to: CGPoint(x: 0, y: tipHeight))

        return path
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ArrowView()
                .previewLayout(.sizeThatFits)
        }
    }
}

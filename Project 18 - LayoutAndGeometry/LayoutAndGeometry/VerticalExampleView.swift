//
//  VerticalExampleView.swift
//  LayoutAndGeometry
//
//  Created by Massimo Omodei on 23.02.21.
//

import SwiftUI

struct VerticalExampleView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(0 ..< 100) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.largeTitle)
                            .frame(width: fullView.size.width)
                            .background(colors[index % colors.count])
                            .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY - fullView.size.height / 2) / 5),
                                              axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(height: 50)
                }
            }
        }
    }
}

struct VerticalExampleView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalExampleView()
    }
}

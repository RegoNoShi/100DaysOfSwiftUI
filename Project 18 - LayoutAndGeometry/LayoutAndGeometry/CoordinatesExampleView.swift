//
//  CoordinatesExampleView.swift
//  LayoutAndGeometry
//
//  Created by Massimo Omodei on 23.02.21.
//

import SwiftUI

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            
            InnerView()
                .background(Color.green)
            
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    private let centerFrameSize: CGFloat = 80
    
    var body: some View {
        HStack {
            Text("Left")
            
            GeometryReader { geo in
                Text("Center")
                    .frame(width: centerFrameSize, height: centerFrameSize)
                    .background(Color.blue)
                    .offset(x: (geo.size.width - centerFrameSize) / 2, y: (geo.size.height - centerFrameSize) / 2)
                    .onTapGesture {
                        print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                        print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                        print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                    }
            }
            .background(Color.orange)
            
            Text("Right")
        }
    }
}

struct CoordinatesExampleView: View {
    var body: some View {
        OuterView()
            .background(Color.red)
            .coordinateSpace(name: "Custom")
    }
}

struct CoordinatesExampleView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatesExampleView()
    }
}

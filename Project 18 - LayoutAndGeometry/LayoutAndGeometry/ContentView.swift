//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Massimo Omodei on 23.02.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CustomAlignmentExample()
                .tabItem {
                    Image(systemName: "text.aligncenter")
                    Text("Custom Alignment")
                }
            
            CoordinatesExampleView()
                .tabItem {
                    Image(systemName: "camera.metering.center.weighted")
                    Text("Coordinates")
                }
            
            VerticalExampleView()
                .tabItem {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Vertical")
                }
            
            HorizontalExampleView()
                .tabItem {
                    Image(systemName: "arrow.left.arrow.right")
                    Text("Horizontal")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

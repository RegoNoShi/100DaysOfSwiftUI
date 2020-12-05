//
//  MainView.swift
//  Drawing
//
//  Created by Massimo Omodei on 05.12.20.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Color Cycling Shape", destination: ColorCyclingShapeTestView())
                NavigationLink("Arrow", destination: ArrowTestView())
            }
            .navigationTitle("Drawing")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

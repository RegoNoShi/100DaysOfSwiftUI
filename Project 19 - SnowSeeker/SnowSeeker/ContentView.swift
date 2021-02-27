//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ResortsListView()
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
    }
}

private extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

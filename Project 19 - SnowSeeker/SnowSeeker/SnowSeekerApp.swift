//
//  SnowSeekerApp.swift
//  SnowSeeker
//
//  Created by Massimo Omodei on 26.02.21.
//

import SwiftUI

@main
struct SnowSeekerApp: App {
    private let favorites = Favorites()
    private let filters = Filters()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favorites)
                .environmentObject(filters)
        }
    }
}

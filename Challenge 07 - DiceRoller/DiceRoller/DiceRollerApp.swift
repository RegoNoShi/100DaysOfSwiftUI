//
//  DiceRollerApp.swift
//  DiceRoller
//
//  Created by Massimo Omodei on 24.02.21.
//

import SwiftUI

@main
struct DiceRollerApp: App {
    @StateObject private var model = DiceRollerModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
                .environment(\.managedObjectContext, model.managedObjectContext)
        }
    }
}

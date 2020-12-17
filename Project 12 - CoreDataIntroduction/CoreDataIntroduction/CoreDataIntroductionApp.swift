//
//  CoreDataIntroductionApp.swift
//  CoreDataIntroduction
//
//  Created by Massimo Omodei on 14.12.20.
//

import SwiftUI

@main
struct CoreDataIntroductionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

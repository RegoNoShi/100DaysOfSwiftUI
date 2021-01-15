//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Massimo Omodei on 17.12.20.
//

import SwiftUI

@main
struct FriendFaceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            UsersView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

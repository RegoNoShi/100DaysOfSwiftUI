//
//  PeopleReminderApp.swift
//  PeopleReminder
//
//  Created by Massimo Omodei on 16.02.21.
//

import SwiftUI

@main
struct PeopleReminderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(model: PeopleReminderModel())
        }
    }
}

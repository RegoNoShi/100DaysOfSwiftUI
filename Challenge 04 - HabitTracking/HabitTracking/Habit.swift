//
//  Habit.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var progress: [HabitProgress] = []
}

struct HabitProgress: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var duration: Double?
    var notes: String?
}

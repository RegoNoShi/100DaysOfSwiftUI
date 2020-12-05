//
//  PreviewData.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import Foundation

class PreviewData {
    static var model: HabitTrackingModel {
        let model = HabitTrackingModel(habits: [
            Habit(title: "Learn German", description: "Practice with German every day"),
            Habit(title: "Jogging", description: "Practice at least twice per week")
        ])

        model.add(progress: HabitProgress(date: Date(), duration: 2, notes: "Read Reddit"), toHabit: model.habits[0])
        model.add(progress: HabitProgress(date: Date(), duration: 1, notes: "Practice on Duolingo"), toHabit: model.habits[0])
        model.add(progress: HabitProgress(date: Date(), duration: 0.5, notes: "Watch TV"), toHabit: model.habits[0])

        return model
    }
}

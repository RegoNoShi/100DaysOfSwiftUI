//
//  HabitTrackingModel.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import Foundation

class HabitTrackingModel: ObservableObject {
    @Published private(set) var habits: [Habit] {
        didSet {
            persistHabits()
        }
    }

    init(habits: [Habit]? = nil) {
        self.habits = habits ?? HabitTrackingModel.getPersistedHabits() ?? []
    }

    func habit(withId id: UUID) -> Habit? {
        habits.first(where: { habit in habit.id == id })
    }

    func add(habit: Habit) {
        habits.append(habit)
    }

    func removeHabit(atOffsets offsets: IndexSet) {
        habits.remove(atOffsets: offsets)
    }

    func moveHabit(from source: IndexSet, to destination: Int) {
        habits.move(fromOffsets: source, toOffset: destination)
    }

    func add(progress: HabitProgress, toHabit habit: Habit) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habit.id }) else {
            fatalError("Got habit with unknown ID")
        }

        habits[habitIndex].progress.append(progress)
        habits[habitIndex].progress.sort(by: sortProgressByDate)
    }

    func removeProgress(atOffsets offsets: IndexSet, fromHabit habit: Habit) {
        guard let habitIndex = habits.firstIndex(where: { $0.id == habit.id }) else {
            fatalError("Got habit with unknown ID")
        }


        habits[habitIndex].progress.remove(atOffsets: offsets)
    }

    private func sortProgressByDate(first: HabitProgress, second: HabitProgress) -> Bool {
        return first.date > second.date
    }

    private static let habitsKey = "habits"

    private func persistHabits() {
        guard let data = try? JSONEncoder().encode(habits) else {
            fatalError("Unable to encode habits")
        }

        UserDefaults.standard.set(data, forKey: HabitTrackingModel.habitsKey)
    }

    private static func getPersistedHabits() -> [Habit]? {
        guard let data = UserDefaults.standard.data(forKey: HabitTrackingModel.habitsKey) else {
            return nil
        }

        guard let persistedHabits = try? JSONDecoder().decode([Habit].self, from: data) else {
            fatalError("Unable to decode habits")
        }

        return persistedHabits
    }
}

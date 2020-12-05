//
//  HabitDetailsView.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import SwiftUI

struct HabitDetailsView: View {
    @StateObject private var model: HabitTrackingModel
    @State private var showAddProgress = false
    @State private var editMode: EditMode = .inactive

    private var habit: Habit

    init(habitId: UUID, model: HabitTrackingModel) {
        guard let habit = model.habit(withId: habitId) else {
            fatalError("Got unknown habit ID")
        }

        self.habit = habit
        _model = StateObject(wrappedValue: model)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(habit.description)
                .padding()

            Text("Progress:")
                .font(.title2)
                .padding()

            List {
                ForEach(habit.progress) { prog in
                    VStack(alignment: .leading) {
                        Text(prog.notes ?? prog.displayableDetails)
                            .font(.headline)

                        if (prog.notes != nil) {
                            Text(prog.displayableDetails)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    model.removeProgress(atOffsets: indexSet, fromHabit: habit)
                })
            }
        }
        .sheet(isPresented: $showAddProgress) {
            AddHabitProgressView(onSave: { progress in
                model.add(progress: progress, toHabit: habit)
                showAddProgress.toggle()
            })
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
                    .disabled(model.habits.isEmpty)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddProgress.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .disabled(editMode.isEditing)
            }
        }
        .environment(\.editMode, $editMode)
        .navigationTitle(habit.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HabitDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HabitDetailsView(habitId: PreviewData.model.habits[0].id, model: PreviewData.model)
        }
    }
}

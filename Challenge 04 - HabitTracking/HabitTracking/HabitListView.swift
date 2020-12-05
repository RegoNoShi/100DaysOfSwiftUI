//
//  HabitListView.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import SwiftUI

struct HabitListView: View {
    @StateObject var model = HabitTrackingModel()
    @State private var showAddHabit = false
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List {
                ForEach(model.habits) { habit in
                    NavigationLink(destination: HabitDetailsView(habitId: habit.id, model: model), label: {
                        VStack(alignment: .leading) {
                            Text(habit.title)
                                .font(.headline)

                            Text(habit.description)
                        }
                    })
                }
                .onDelete(perform: model.removeHabit)
                .onMove(perform: model.moveHabit)
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(onSave: { habit in
                    model.add(habit: habit)
                    showAddHabit.toggle()
                })
            }
            .navigationTitle("Habit Tracking")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(model.habits.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddHabit.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(editMode.isEditing)
                }
            }
            .environment(\.editMode, $editMode)
        }
        .onReceive(model.$habits, perform: { habits in
            if habits.isEmpty && editMode.isEditing {
                editMode = .inactive
            }
        })
    }
}

struct HabitListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView(model: PreviewData.model)
    }
}

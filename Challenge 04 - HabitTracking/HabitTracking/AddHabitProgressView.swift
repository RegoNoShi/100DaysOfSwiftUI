//
//  AddHabitProgressView.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import SwiftUI

struct AddHabitProgressView: View {
    var onSave: (HabitProgress) -> Void

    @State private var notes = ""
    @State private var date = Date()
    @State private var duration = 1.0
    @State private var addDuration = false

    private var trimmedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Progress")) {
                    DatePicker(selection: $date, displayedComponents: .date) {
                        Text("Date")
                    }

                    TextField("Notes (optional)", text: $notes)

                    Toggle(isOn: $addDuration.animation()) {
                        Text("Add a duration")
                    }

                    if addDuration {
                        Stepper("\(duration.asFormattedDuration)", value: $duration, in: 0.25...24, step: 0.25)
                    }
                }
            }
            .navigationTitle("Add Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(HabitProgress(date: date, duration: duration, notes: trimmedNotes.isEmpty ? nil : trimmedNotes))
                    }
                }
            }
        }
    }
}

struct AddHabitProgressView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .sheet(isPresented: .constant(true)) {
                AddHabitProgressView { habit in
                    print(habit)
                }
            }
    }
}

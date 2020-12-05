//
//  AddHabitView.swift
//  HabitTracking
//
//  Created by Massimo Omodei on 25.11.20.
//

import SwiftUI

struct AddHabitView: View {
    var onSave: (Habit) -> Void

    @State private var title = ""
    @State private var description = ""

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedDescription: String {
        description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Habit")) {
                    TextField("Title", text: $title)
                    TextField("Descriptiion", text: $description)
                }
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(Habit(title: trimmedTitle, description: trimmedDescription))
                    }
                    .disabled(trimmedTitle.isEmpty || trimmedDescription.isEmpty)
                }
            }
        }
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .sheet(isPresented: .constant(true)) {
                AddHabitView { habit in
                    print(habit)
                }
            }
    }
}
